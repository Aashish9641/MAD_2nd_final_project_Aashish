import SwiftUI

struct UserLogin: View {
    @State private var email = ""
    @State private var password = ""
    @State private var mesDispla = ""
    @State private var isRegisterActive = false
    @State private var okLogi = false
    
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                // Main Content
                VStack(spacing: 19) {
                    // Title
                    Text("User Login")
                        .font(.system(size: 35, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                        .padding(.top, 39)
                    
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
                    if !mesDispla.isEmpty {
                        ErmSm(text: mesDispla)
                    }
                    
                    // Login Button
                    Button(action: partLog) {
                        HStack {
                            Text("LOGIN")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: Color.blue.opacity(0.4), radius: 11, x: 0, y: 11)
                    }
                    .padding(.vertical, 19)
                    
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
                .padding(.horizontal, 29)
            }
            .navigationBarHidden(true)
            .background(
                NavigationLink(destination: UserView(), isActive: $okLogi) {
                    EmptyView()
                }
            )
        }
    }
    
    // MARK: - Helper Functions
    
    private func partLog() {
        if valFir() {
            if dataManager.useVal(email: email, password: password) {
                okLogi = true // Directly trigger navigation
            } else {
                mesDispla = "Invalid email or password."
            }
        }
    }
    
    private func valFir() -> Bool {
        if email.isEmpty || password.isEmpty {
            mesDispla = "Please fill in all required fields."
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
