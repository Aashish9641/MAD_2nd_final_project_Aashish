import SwiftUI

@available(iOS 13.0, *) // Ensure compatibility with iOS 13 and later
struct LandlordLogin: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var username = ""
    @State private var email = ""
    @State private var errorMessage = ""
    @State private var isLoggedIn = false
    @State private var loggedInLandlord: Landlord? = nil
    
    // Custom Color Scheme
    private let primaryColor = Color(red: 0.11, green: 0.37, blue: 0.53) // Deep Blue
    private let secondaryColor = Color(red: 0.92, green: 0.94, blue: 0.96) // Light Gray
    private let successColor = Color(red: 0.23, green: 0.64, blue: 0.53) // Teal Green
    
    var onSuccess: () -> Void // Callback for successful login
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .font(.system(size: 40))
                        .foregroundColor(primaryColor)
                    
                    Text("Landlord Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(.top, 40)
                
                // Form Fields
                VStack(spacing: 16) {
                    CustomTextField(icon: "person.fill", placeholder: "Username", text: $username)
                    CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding(.horizontal)
                
                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
                
                // Login Button
                Button(action: login) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Login")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [primaryColor, successColor]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: primaryColor.opacity(0.3), radius: 8, y: 4)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(secondaryColor.edgesIgnoringSafeArea(.all))
            .navigationTitle("Landlord Login")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Reset fields when the view appears
                username = ""
                email = ""
                errorMessage = ""
            }
            .background(
                Group {
                    if let landlord = loggedInLandlord {
                        if #available(iOS 15.0, *) {
                            NavigationLink(
                                destination: LandlordDashboard(landlord: landlord),
                                isActive: $isLoggedIn
                            ) { EmptyView() }
                        } else {
                            // Fallback for earlier versions
                            if #available(iOS 15.0, *) {
                                NavigationLink(
                                    destination: LandlordDashboard(landlord: landlord),
                                    isActive: $isLoggedIn
                                ) { EmptyView() }
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                }
            )
        }
    }
    
    // Custom Text Field Component
    struct CustomTextField: View {
        let icon: String
        let placeholder: String
        @Binding var text: String
        
        var body: some View {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                TextField(placeholder, text: $text)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 3, y: 2)
        }
    }
    
    // Login Action
    private func login() {
        if username.isEmpty || email.isEmpty {
            errorMessage = "Please fill in all fields"
            return
        }
        
        if dataManager.lordValidation(username: username, email: email) {
            loggedInLandlord = dataManager.lordGet(username: username, email: email)
            isLoggedIn = true
            onSuccess() // Call the onSuccess closure
        } else {
            errorMessage = "Invalid Username or Email"
        }
    }
}
