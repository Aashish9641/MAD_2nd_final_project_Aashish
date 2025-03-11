import SwiftUI

struct ContentView: View {
    @State private var isAdminSelected = false
    @State private var isLandlordSelected = false
    @State private var isUserSelected = false
    @State private var showSideMenu = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dynamic Gradient Background
                if #available(iOS 15.0, *) {
                    AngularGradient(gradient: Gradient(colors: [.indigo, .blue, .purple, .pink]), center: .topTrailing)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(Color.black.opacity(0.3))
                } else {
                    // Fallback on earlier versions
                }
                
                // Main Content
                VStack(spacing: 20) {
                    // Enhanced Header
                    HeaderView(showSideMenu: $showSideMenu)
                        .padding(.top, 40)
                    
                    // Animated Title
                    Text("Advertise Your Properties")
                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 40 : 30, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 20)
                        .shadow(radius: 5)
                        .transition(.opacity)
                    
                    // Interactive Cards
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 25) {
                            // Admin Card
                            NavigationCard(
                                title: "Admin Panel",
                                subtitle: "Manage Landlords",
                                icon: "person.badge.key.fill",
                                color: .blue,
                                destination: AdminLoginView(),
                                isActive: $isAdminSelected
                            )
                            
                            // Landlord Card
                            NavigationCard(
                                title: "Landlord Portal",
                                subtitle: "Manage The properties",
                                icon: "house.fill",
                                color: .green,
                                destination: LandlordLogin(onSuccess: { isLandlordSelected = true }),
                                isActive: $isLandlordSelected
                            )
                            
                            // User Card
                            NavigationCard(
                                title: "Explore Properties",
                                subtitle: "Find the properties",
                                icon: "magnifyingglass",
                                color: .orange,
                                destination: UserLogin(),
                                isActive: $isUserSelected
                            )
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
                
                // Modern Side Menu
                SideMenuView(showSideMenu: $showSideMenu)
                    .offset(x: showSideMenu ? 0 : -UIScreen.main.bounds.width)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showSideMenu)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Enhanced Header
struct HeaderView: View {
    @Binding var showSideMenu: Bool
    
    var body: some View {
        HStack {
            // Hamburger Menu Button
            Button(action: {
                withAnimation { showSideMenu.toggle() }
                hapticFeedback()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text("PropertyAds")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding(12)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

// MARK: - Navigation Card Component
struct NavigationCard<Destination: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let destination: Destination
    @Binding var isActive: Bool
    
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: destination, isActive: $isActive) { EmptyView() }
        
        Button(action: {
            hapticFeedback()
            isActive = true
        }) {
            HStack(spacing: 20) {
                // Icon Container
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(20)
            .scaleEffect(isPressed ? 0.95 : 1)
            .shadow(color: color.opacity(0.3), radius: 15, x: 0, y: 10)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
        }
        .buttonStyle(CardButtonStyle(isPressed: $isPressed))
    }
}

// MARK: - Modern Side Menu
struct SideMenuView: View {
    @Binding var showSideMenu: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                // Profile Section
                HStack(spacing: 15) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading) {
                        Text("Welcome")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Guest User")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.1))
                
                // Menu Items
                VStack(spacing: 12) {
                    MenuItem(icon: "house.fill", title: "Home")
                    MenuItem(icon: "gearshape.fill", title: "Settings")
                    MenuItem(icon: "info.circle.fill", title: "About")
                    MenuItem(icon: "questionmark.circle.fill", title: "Help")
                }
                .padding(.vertical, 20)
                .padding(.horizontal)
                
                Spacer()
                
                // Close Button
                Button(action: {
                    withAnimation { showSideMenu.toggle() }
                    hapticFeedback()
                }) {
                    HStack {
                        Spacer()
                        Text("Close Menu")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding()
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.7)
            .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)))
            
            Spacer()
        }
    }
}

// MARK: - Reusable Components
struct MenuItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .frame(width: 25)
                .foregroundColor(.white)
            
            Text(title)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.0001)) // For tap area
        .contentShape(Rectangle())
    }
}

struct CardButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .onChange(of: configuration.isPressed) { newValue in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPressed = newValue
                }
            }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}

// MARK: - Helper Functions
func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
