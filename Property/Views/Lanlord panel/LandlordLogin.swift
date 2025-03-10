import SwiftUI

struct LandlordLogin: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var username = ""
    @State private var email = ""
    @State private var errorMessage = ""
    @State private var isLoggedIn = false
    @State private var loggedInLandlord: Landlord? = nil
    
    var onSuccess: () -> Void // Callback for successful login
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Landlord Login")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                // Username Field
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                // Email Field
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                // Login Button
                Button("Login") {
                    if dataManager.lordValidation(username: username, email: email) {
                        // Get the logged-in landlord
                        loggedInLandlord = dataManager.lordGet(username: username, email: email)
                        isLoggedIn = true
                        onSuccess() // Call the onSuccess closure
                    } else {
                        errorMessage = "Invalid Username or Email"
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                // Navigate to LandlordDashboard on successful login
                if let landlord = loggedInLandlord {
                    if #available(iOS 15.0, *) {
                        NavigationLink("", destination: LandlordDashboard(landlord: landlord), isActive: $isLoggedIn)
                    } else {
                        // Fallback on earlier versions
                    };if #available(iOS 15.0, *) {
                        NavigationLink("", destination: LandlordDashboard(landlord: landlord), isActive: $isLoggedIn)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            .padding()
            .navigationTitle("Landlord Login")
        }
    }
}
