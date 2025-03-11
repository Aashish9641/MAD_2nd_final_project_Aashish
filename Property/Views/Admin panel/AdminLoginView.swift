import SwiftUI

struct AdminLoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoginSuccessful = false
    @State private var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode // For back button
    
    let adminUsername = "Admin"
    let adminPassword = "Admin123"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                // Main Content
                ScrollView {
                    VStack(spacing: 20) {
                        // Back Button
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss() // Go back
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            Spacer()
                        }
                        .padding(.top, geometry.safeAreaInsets.top) // Adjust for safe area
                        
                        // Title
                        Text("Admin Login")
                            .font(.system(size: geometry.size.width > 600 ? 40 : 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        // Username Field
                        CustomTextField(placeholder: "Username", text: $username, iconName: "person.fill")
                            .frame(width: geometry.size.width * 0.8) // 80% of screen width
                        
                        // Password Field
                        CustomTextField(placeholder: "Password", text: $password, iconName: "lock.fill", isSecure: true)
                            .frame(width: geometry.size.width * 0.8) // 80% of screen width
                        
                        // Login Button
                        ButtonCus(title: "Login", backgroundColor: .blue, action: {
                            if username == adminUsername && password == adminPassword {
                                isLoginSuccessful = true
                            } else {
                                showAlert = true
                            }
                        })
                        .frame(width: geometry.size.width * 0.8) // 80% of screen width
                        .padding(.top, 20)
                        
                        // Go to Landlord Login Button
                        NavigationLink(destination: LandlordLogin(onSuccess: {})) {
                            Text("Go to Landlord Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(10)
                                .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 5)
                        }
                        .frame(width: geometry.size.width * 0.8) // 80% of screen width
                        
                        // Go to User Login Button
                        NavigationLink(destination: UserLogin()) {
                            Text("Go to User Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .cornerRadius(10)
                                .shadow(color: Color.orange.opacity(0.3), radius: 5, x: 0, y: 5)
                        }
                        .frame(width: geometry.size.width * 0.8) // 80% of screen width
                        
                        Spacer()
                    }
                    .frame(width: geometry.size.width) // Full width
                    .padding(.horizontal, 20)
                }
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
