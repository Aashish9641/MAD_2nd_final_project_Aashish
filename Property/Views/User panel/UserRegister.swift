import SwiftUI

struct UserRegister: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var throwEr = ""
    @State private var mshowUs = false
    @State private var gotoLogin = false
    
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.4, blue: 0.5), Color(red: 0.2, green: 0.4, blue: 0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Main Content
            VStack(spacing: 14) {
                // Title
                Text("User Register")
                    .font(.system(size: 35, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                    .padding(.top, 39)
                
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
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(11)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 11)
                            .stroke(Color.white.opacity(0.6), lineWidth: 1)
                    )
                
                // Confirm Password Field
                SecureField("Confirm your Password", text: $confirmPassword)
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                
                // Error Message
                if !throwEr.isEmpty {
                    ThrowEr(text: throwEr)
                }
                
                // Register Button
                Button(action: sideReg) {
                    HStack {
                        Text("REGISTER")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.2, green: 0.8, blue: 0.6), Color(red: 0.1, green: 0.6, blue: 0.8)]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color(red: 0.2, green: 0.7, blue: 0.6).opacity(0.3), radius: 11, x: 0, y: 10)
                }
                .padding(.vertical, 20)
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .alert(isPresented: $mshowUs) {
            Alert(
                title: Text("Success"),
                message: Text("Registration successful! You will be redirected to the login page."),
                dismissButton: .default(Text("OK")) {
                    gotoLogin = true
                }
            )
        }
        .background(
            NavigationLink(destination: UserLogin(), isActive: $gotoLogin) {
                EmptyView()
            }
        )
        .navigationBarBackButtonHidden(true) // Hide back button on UserRegister screen
    }
    
    // MARK: - Helper Functions
    
    private func sideReg() {
        if rightFie() {
            if dataManager.plusUse(name: name, email: email, password: password) {
                mshowUs = true
            } else {
                throwEr = "provided enmail is  already exists."
            }
        }
    }
    
    private func rightFie() -> Bool {
        if name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            throwEr = "Please fill in all fields."
            return false
        }
        
        if password != confirmPassword {
            throwEr = "Passwords do not match."
            return false
        }
        
        return true
    }
}

// MARK: - Reusable Components

struct ThrowEr: View {
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
