import SwiftUI

struct ContentView: View {
    @State private var isAdminSelected = false
    @State private var isLandlordSelected = false
    @State private var isUserSelected = false
    @State private var showSideMenu = false
    
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
                    // Header with Hamburger Icon
                    HeaderView(showSideMenu: $showSideMenu)
                        .padding(.top, 40)
                    
                    // Title
                    Text("Advertise Your Properties")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 20)
                    
                    // Buttons
                    VStack(spacing: 20) {
                        // Admin Login Button
                        NavigationLink(destination: AdminLoginView(), isActive: $isAdminSelected) {
                            CustomButton(title: "Admin Login", backgroundColor: .blue, action: {
                                isAdminSelected = true
                            })
                        }
                        
                        // Landlord Login Button
                        NavigationLink(destination: LandlordLogin(onSuccess: {
                            isLandlordSelected = true
                        }), isActive: $isLandlordSelected) {
                            CustomButton(title: "Landlord Login", backgroundColor: .green, action: {
                                isLandlordSelected = true
                            })
                        }
                        
                        // User View Button
                        NavigationLink(destination: UserView(), isActive: $isUserSelected) {
                            CustomButton(title: "User View", backgroundColor: .orange, action: {
                                isUserSelected = true
                            })
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                
                // Side Menu (Hamburger Menu)
                if showSideMenu {
                    SideMenuView(showSideMenu: $showSideMenu)
                        .transition(.move(edge: .leading))
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Header View (Fragment/Reusable Component)
struct HeaderView: View {
    @Binding var showSideMenu: Bool
    
    var body: some View {
        HStack {
            // Hamburger Icon
            Button(action: {
                withAnimation {
                    showSideMenu.toggle()
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

// Side Menu View (Fragment/Reusable Component)
struct SideMenuView: View {
    @Binding var showSideMenu: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Close Button
            Button(action: {
                withAnimation {
                    showSideMenu.toggle()
                }
            }) {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
            
            // Menu Items
            Text("Home")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
            
            Text("Settings")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
            
            Text("About")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.7)
        .background(Color.blue.opacity(0.9))
        .edgesIgnoringSafeArea(.all)
    }
}

// Custom Button (Fragment/Reusable Component)
struct CustomButton: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: backgroundColor.opacity(0.3), radius: 5, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1)
        .animation(.easeInOut(duration: 0.2), value: backgroundColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
