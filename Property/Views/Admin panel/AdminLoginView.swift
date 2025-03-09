import SwiftUI

struct AdminLoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoginSuccessful = false
    @State private var showAlert = false
    
    let adminUsername = "Admin"
    let adminPassword = "Admin123"
    
    var body: some View {
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
                Text("Admin Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // Username Field
                CustomTextField(placeholder: "Username", text: $username, iconName: "person.fill")
                
                // Password Field
                CustomTextField(placeholder: "Password", text: $password, iconName: "lock.fill", isSecure: true)
                
                // Login Button
                CustomButton(title: "Login", backgroundColor: .blue, action: {
                    if username == adminUsername && password == adminPassword {
                        isLoginSuccessful = true
                    } else {
                        showAlert = true
                    }
                })
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .navigationBarHidden(true)
        .background(
            NavigationLink(destination: AdminDashboardView(), isActive: $isLoginSuccessful) {
                EmptyView()
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Login Failed"),
                message: Text("Incorrect username or password."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// Custom Text Field (Fragment/Reusable Component)
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let iconName: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
            } else {
                TextField(placeholder, text: $text)
                    .padding()
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct AdminLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AdminLoginView()
    }
}
