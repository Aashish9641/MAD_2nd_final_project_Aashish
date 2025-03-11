import SwiftUI

struct UserRegister: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var showSuccessMessage = false
    @State private var navigateToLogin = false
    
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.1, green: 0.3, blue: 0.6), Color(red: 0.2, green: 0.5, blue: 0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Main Content
            VStack(spacing: 20) {
                // Title
                Text("User Register")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    .padding(.top, 40)
                
                // Name Field
                TextField("Name", text: $name)
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                
                // Email Field
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                
                // Password Field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                
                // Confirm Password Field
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                
                // Error Message
                if !errorMessage.isEmpty {
                    ErrorMessage(text: errorMessage)
                }
                
                // Register Button
                Button(action: handleRegister) {
                    HStack {
                        Text("REGISTER")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.2, green: 0.8, blue: 0.6), Color(red: 0.1, green: 0.6, blue: 0.8)]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color(red: 0.2, green: 0.8, blue: 0.6).opacity(0.3), radius: 10, x: 0, y: 10)
                }
                .padding(.vertical, 20)
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .alert(isPresented: $showSuccessMessage) {
            Alert(
                title: Text("Success"),
                message: Text("Registration successful! You will be redirected to the login page."),
                dismissButton: .default(Text("OK")) {
                    navigateToLogin = true
                }
            )
        }
        .background(
            NavigationLink(destination: UserLogin(), isActive: $navigateToLogin) {
                EmptyView()
            }
        )
        .navigationBarBackButtonHidden(true) // Hide back button on UserRegister screen
    }
    
    // MARK: - Helper Functions
    
    private func handleRegister() {
        if validateFields() {
            if dataManager.addUser(name: name, email: email, password: password) {
                showSuccessMessage = true
            } else {
                errorMessage = "Email already exists."
            }
        }
    }
    
    private func validateFields() -> Bool {
        if name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Please fill in all fields."
            return false
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return false
        }
        
        return true
    }
}

// MARK: - Reusable Components

struct ErrorMessage: View {
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(text)
                .font(.caption)
                .foregroundColor(.red)
        }
        .padding(10)
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}

struct UserRegister_Previews: PreviewProvider {
    static var previews: some View {
        UserRegister()
    }
}
