import SwiftUI

struct UserLogin: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isRegisterActive = false
    @State private var isLoginSuccessful = false
    
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                // Main Content
                VStack(spacing: 20) {
                    // Title
                    Text("User Login")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .padding(.top, 40)
                    
                    // Email Field
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .foregroundColor(.white)
                    
                    // Password Field
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
                    // Error Message
                    if !errorMessage.isEmpty {
                        ErmSm(text: errorMessage)
                    }
                    
                    // Login Button
                    Button(action: handleLogin) {
                        HStack {
                            Text("LOGIN")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 10)
                    }
                    .padding(.vertical, 20)
                    
                    // Register Link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        
                        NavigationLink(destination: UserRegister(), isActive: $isRegisterActive) {
                            Text("Register")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .underline()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
            }
            .navigationBarHidden(true)
            .background(
                NavigationLink(destination: UserView(), isActive: $isLoginSuccessful) {
                    EmptyView()
                }
            )
        }
    }
    
    // MARK: - Helper Functions
    
    private func handleLogin() {
        if validateFields() {
            if dataManager.validateUser(email: email, password: password) {
                isLoginSuccessful = true // Directly trigger navigation
            } else {
                errorMessage = "Invalid email or password."
            }
        }
    }
    
    private func validateFields() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields."
            return false
        }
        return true
    }
}


// MARK: - Reusable Components

struct ErmSm: View {
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

struct UserLogin_Previews: PreviewProvider {
    static var previews: some View {
        UserLogin()
    }
}
