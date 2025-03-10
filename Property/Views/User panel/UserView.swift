import SwiftUI

struct UserView: View {
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // List all properties
                    ForEach(dataManager.properties, id: \.id) { property in
                        PropertyCardUserView(property: property)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Available Properties")
            .background(Color(.systemGray6))
        }
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
                .foregroundColor(.green)
            
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
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
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
