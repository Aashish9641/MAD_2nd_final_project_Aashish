import SwiftUI

struct UserView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showLogoutButton = false
    @State private var isLoggedOut = false // State for navigation to UserLogin
    
    // Fetch the logged-in user's details
    private var loggedInUser: User? {
        dataManager.users.first // Assuming the first user is the logged-in user
    }
    
    // Get the username or default to "Guest"
    private var username: String {
        loggedInUser?.name ?? "Guest"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Welcome Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hey, Welcome")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("@\(username)")
                            .font(.title2.bold())
                            .foregroundColor(Color.blue)
                    }
                    
                    Spacer()
                    
                    // User Logo (First Letter of Username)
                    Button(action: {
                        withAnimation {
                            showLogoutButton.toggle()
                        }
                    }) {
                        Text(String(username.first ?? "U"))
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.purple)
                            .clipShape(Circle())
                            .shadow(color: Color.purple.opacity(0.3), radius: 5, x: 0, y: 5)
                    }
                    .overlay(
                        // Logout Button
                        VStack {
                            if showLogoutButton {
                                Button(action: {
                                    isLoggedOut = true // Trigger logout
                                }) {
                                    Text("Logout")
                                        .font(.subheadline.bold())
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                        .shadow(color: Color.red.opacity(0.3), radius: 5, x: 0, y: 5)
                                }
                                .transition(.opacity)
                                .padding(.top, 8)
                            }
                        }
                        , alignment: .bottom
                    )
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // List of Properties
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(dataManager.properties, id: \.id) { property in
                            PropertyCardUserView(property: property)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .background(Color(.systemGray6))
            }
            .navigationTitle("Available Properties")
            .navigationBarBackButtonHidden(true) // Hide the back button
            .background(
                NavigationLink(destination: UserLogin(), isActive: $isLoggedOut) {
                    EmptyView()
                }
            )
        }
        .accentColor(.purple) // Accent color for links and navigation
    }
}

// Property Card for User View
struct PropertyCardUserView: View {
    let property: Property
    
    @State private var isShowingContactRequest = false
    @State private var showSuccessMessage = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Property Address
            Text(property.address)
                .font(.headline)
                .foregroundColor(.primary)
            
            // Property Description
            Text(property.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Property Price
            Text("$\(property.price, specifier: "%.2f")/month")
                .font(.subheadline.bold())
                .foregroundColor(Color.green)
            
            // Contact Landlord Button
            Button(action: {
                isShowingContactRequest = true
            }) {
                Text("Request to Contact Landlord")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
                    .shadow(color: Color.purple.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .sheet(isPresented: $isShowingContactRequest) {
            ContactRequestView(property: property, isShowing: $isShowingContactRequest, showSuccessMessage: $showSuccessMessage)
        }
        .overlay(
            Group {
                if showSuccessMessage {
                    SuccessMessageView()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSuccessMessage = false
                            }
                        }
                }
            }, alignment: .top
        )
    }
}

// Contact Request View (Fragment/Reusable Component)
struct ContactRequestView: View {
    let property: Property
    @Binding var isShowing: Bool
    @Binding var showSuccessMessage: Bool
    
    @State private var contactMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Property Details").font(.headline)) {
                    Text(property.address)
                        .font(.subheadline)
                    Text(property.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("$\(property.price, specifier: "%.2f")/month")
                        .font(.subheadline.bold())
                        .foregroundColor(.green)
                }
                
                Section(header: Text("Your Message").font(.headline)) {
                    TextEditor(text: $contactMessage)
                        .frame(height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
            }
            .navigationTitle("Contact Landlord")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isShowing = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Send") {
                        sendContactRequest()
                        isShowing = false
                        showSuccessMessage = true
                    }
                    .disabled(contactMessage.isEmpty)
                }
            }
        }
    }
    
    private func sendContactRequest() {
        // Simulate sending a contact request
        print("Contact request sent for property: \(property.address)")
        print("Message: \(contactMessage)")
        // You can implement actual logic here (e.g., send an email or save to a database)
    }
}

// Success Message View (Fragment/Reusable Component)
struct SuccessMessageView: View {
    var body: some View {
        Text("Message Sent Successfully!")
            .font(.subheadline.bold())
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .padding(.top, 16)
            .transition(.opacity)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
