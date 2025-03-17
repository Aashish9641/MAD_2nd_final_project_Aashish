import SwiftUI // Importing the Swift UI framework

struct ContentView: View { // Main view content as per App content
    @State private var pickAd = false // track if the admin panel is choosen
    @State private var pickLords = false // track if the landlord is chosen
    @State private var userCho = false // tracks if the user is choosen
    @State private var menuVar = false // track if the side bar is visible or not
    
    var body: some View { // Defining the body of the view
        NavigationView { // wrapping the nav bar
            ZStack { // make on top of each other
                //  Setting the Dynamic Gradient Background
                if #available(iOS 15.0, *) { // check if there any IOS 15 or latest is availiable
                    AngularGradient(gradient: Gradient(colors: [.indigo, .blue, .purple, .pink]), center: .topTrailing) // adding the angular gradeint combination
                        .edgesIgnoringSafeArea(.all) // function to avoid safe are to cover whole screen
                        .overlay(Color.black.opacity(0.3)) // set dark overlayfor better contrast
                } else {
                    // Fallback on earlier versions (ios version )
                }
                
                // Main Content Begins here
                VStack(spacing: 20) { // add vertical stack for main content
                    // Improved  Header section
                    viewTop(menuVar: $menuVar) // show the header with side menu as welll
                        .padding(.top, 40) // add padding in top side
                    
                    // Here is teh animated  Title
                    Text("Advertise Your Properties") // main title when user open
                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 39 : 31, weight: .bold)) // as per device type managing the font size
                        .foregroundColor(.white) // add text color as white
                        .multilineTextAlignment(.center) // make it in center align
                        .padding(.vertical, 20) // add vertical padding as 20
                        .shadow(radius: 5) // set the shadow effect
                        .transition(.opacity) // set fade tarnstition
                    
                    // Used interactives  Cards
                    ScrollView(showsIndicators: false) { // add scroeable features
                        VStack(spacing: 25) { // add vertical spacing with space 25
                            // Here is the Admin Card
                            navCar(
                                title: "Admin Panel", // admin card title
                                subtitle: "Manage Landlords", // card subtitle
                                icon: "person.badge.key.fill", // add the card icon
                                color: .red, // make that color bklue
                                destination: AdminLoginView(), // add the path of destination
                                isActive: $pickAd // binding the after the navigation
                            )
                            
                            // Here are Landlord Card section
                            navCar(
                                title: "Landlord Portal", // add the title of card for landlord
                                subtitle: "Manage The properties", // add the subtitles of landlord
                                icon: "house.fill", // add icon for landlord
                                color: .green, // set card color as green
                                destination: LandlordLogin(onSuccess: { pickLords = true }), // provide destination link
                                isActive: $pickLords // binding the navigation section
                            )
                            
                            // Here is User Card section
                            navCar(
                                title: "Explore Properties", // Add the title of card
                                subtitle: "Find the properties", // set the subtitle of card
                                icon: "magnifyingglass", // add required icon
                                color: .orange, // add oragne as color
                                destination: UserLogin(), // provide the required destination
                                isActive: $userCho
                            )
                        }
                        .padding(.horizontal) // add padding in horizontal side
                        .padding(.bottom, 40) // provide the bottm side padding
                    }
                }
                
                // adding the stylish  Side Menu
                sudeMe(menuVar: $menuVar) // show the side bar menu
                    .offset(x: menuVar ? 0 : -UIScreen.main.bounds.width) // making the slide the side bar
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: menuVar) // ass spring animation
            }
            .navigationBarHidden(true) // hiding the nav bar
        }
        .navigationViewStyle(StackNavigationViewStyle()) // using the stack nav design
    }
}

// Here is improved header section
struct viewTop: View { // header view with side menu button
    @Binding var menuVar: Bool // side menu dispaly and binding control
    
    var body: some View { // defining the body of header
        HStack { // add horizontal stack
            // create the Hamburger Menu Button
            Button(action: { // add button toogle side menu
                withAnimation { menuVar.toggle() } // add animation to toogle
                recmUs() // provide haptic suggestion
            }) {
                HStack(spacing: 8) { // add horizontal stack with spacing 8
                    Image(systemName: "line.horizontal.3") // add icon for hamburger
                        .font(.title2) // add the font icon
                        .foregroundColor(.white) // add icon color
                    
                    Text("PropertyAds") // declare the name of app
                        .font(.title3) // add the text size
                        .fontWeight(.semibold) // set text weight
                        .foregroundColor(.white) // add text color as white
                }
                .padding(12) // add padding
                .background(Color.white.opacity(0.1)) // add BG color for button
                .cornerRadius(12) // make the corner radius border
            }
            
            Spacer() // push the element to left side
        }
        .padding(.horizontal) // add required padding in horizontal side
    }
}

// Using componenets for nav card
struct navCar<Destination: View>: View { // Reuseable nav card elements
    let title: String // card title declaration
    let subtitle: String // add card subtitle
    let icon: String // add card icon
    let color: Color // add color for card
    let destination: Destination // add path view
    @Binding var isActive: Bool // add binding the nav state
    
    @State private var isPressed = false // Tracks if teh card is clicked
    
    var body: some View { // Define teh body of card
        NavigationLink(destination: destination, isActive: $isActive) { EmptyView() } // invisible nav link
        
        Button(action: { // add button to handle card tap
            recmUs() // give haptic suggestion or feedback
            isActive = true // activate nav
        }) {
            HStack(spacing: 20) { // horizontal stack for card componets
                // settin Icon Container
                ZStack { // add stack for icon and BG
                    Circle() // make rounder background
                        .fill(color) // add BG color
                        .frame(width: 49, height: 49) // adding the size
                    
                    Image(systemName: icon) // set the card icon
                        .font(.system(size: 22))// add icon size
                        .foregroundColor(.white) // add the icon color
                }
                
                VStack(alignment: .leading, spacing: 4) { // add vertical stack with spacing
                    Text(title) // card title added
                        .font(.system(size: 20, weight: .semibold)) // set font size and weight
                        .foregroundColor(.white) // add color text
                    
                    Text(subtitle) // add the subtitle of card
                        .font(.subheadline) // add font size
                        .foregroundColor(.white.opacity(0.9)) // add color with required opacity
                }
                
                Spacer() // bring content to left side of screen
                
                Image(systemName: "chevron.right") // set chervron icon
                    .font(.system(size: 16, weight: .bold)) //add icon and weight
                    .foregroundColor(.white.opacity(0.7)) // add icon color and opacity
            }
            .padding() // add padding necessary
            .background(Color.white.opacity(0.1)) // add card background
            .cornerRadius(20) // making round the radius
            .scaleEffect(isPressed ? 0.96 : 1) // implement scale effect when clicked
            .shadow(color: color.opacity(0.3), radius: 15, x: 0, y: 10) // execute shadow effect
            .animation(.easeInOut(duration: 0.2), value: isPressed) // set animation
        }
        .buttonStyle(btnCar(isPressed: $isPressed)) // declare custom button design
    }
}

// setting  Modern Side Menu bar
struct sudeMe: View { // view for side menu
    @Binding var menuVar: Bool // binding control of side var dispaly
    
    var body: some View { // body of the side menu
        HStack { // add horizontal stack
            VStack(alignment: .leading, spacing: 0) { // set vertical stack for body content
                // Begins the Profile Section
                HStack(spacing: 15) { // add horizontal stack for profile section
                    Image(systemName: "person.crop.circle.fill") // add the icon of porfile
                        .resizable() // add the icon resizeable as per screen
                        .frame(width: 50, height: 50) // add the icon size
                        .foregroundColor(.white) // add icon color
                    
                    VStack(alignment: .leading) { // vertical stack  for profile text
                        Text("Welcome") // text message like welcoing text
                            .font(.subheadline) // set font size
                            .foregroundColor(.white.opacity(0.8)) // set text color with required opacity
                        
                        Text("Guest User") // add text for user name as guest
                            .font(.headline) // add font size
                            .foregroundColor(.white) // set the color text
                    }
                    
                    Spacer() // bring the text content to left side
                }
                .padding() // add necessay padding
                .background(Color.white.opacity(0.1)) // add background color
                
                // Menu Items bars
                VStack(spacing: 12) { // add vertical stack for menu
                    reMe(icon: "house.fill", title: "Home") // add home menu icon
                    reMe(icon: "gearshape.fill", title: "Settings") // add setting menu icon
                    reMe(icon: "info.circle.fill", title: "About") // add about icon
                    reMe(icon: "questionmark.circle.fill", title: "Help") //add help menu icon
                }
                .padding(.vertical, 20) // Add vertical padding section
                .padding(.horizontal) //add necessay padding in horizontal side
                
                Spacer() //make the space and bring components in left side on screen
                
                // Adding Close Button
                Button(action: { // Button to close the side nav var
                    withAnimation { menuVar.toggle() } // operate the toogle with animation
                    recmUs() // provide haptic feedback or suggestion
                }) {
                    HStack { // add horizontal stack for button content
                        Spacer() // adding the space
                        Text("Close Menu") // add the button text
                            .font(.subheadline) // set font size
                            .foregroundColor(.white) // add text color
                        Spacer() // Add space
                    }
                    .padding() // Add required padding
                    .background(Color.white.opacity(0.1)) // Adding the BG button
                    .cornerRadius(12) // making the round corner s
                    .padding() // add padding
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.6) // add the width of side menu
            .background(effeV(effect: UIBlurEffect(style: .systemMaterialDark))) // add blured background
            
            Spacer() //  add space to push the menu to left side
        }
    }
}
// resuable elements
struct reMe: View { // Reuseable menu item element
    let icon: String // add menu icon
    let title: String // menu title
    
    var body: some View { // defining the body of the menu icon
        HStack(spacing: 14) { // add horizontal stack with spacing
            Image(systemName: icon) // add icon for menu item
                .frame(width: 25) // declare the size of icon
                .foregroundColor(.white) // add icon color as well
            
            Text(title) // menu item title
                .foregroundColor(.white) // add text color
            
            Spacer() // add contnet to push contnet to left side of screen
        }
        .padding(11.5) // add necessay padding
        .background(Color.white.opacity(0.0001)) // setting the  tap area
        .contentShape(Rectangle()) // Defineing the  tap area
    }
}

struct btnCar: ButtonStyle { // Adding the custom button design for cards
    @Binding var isPressed: Bool // binding to trace when the button is clicked
    
    func makeBody(configuration: Configuration) -> some View { // funnction to define button style
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1) // add scale label effect when clicked
            .onChange(of: configuration.isPressed) { newValue in // tracing the button click stage
                withAnimation(.easeInOut(duration: 0.2)) { // add required animation style
                    isPressed = newValue // modify the pressed stage
                }
            }
    }
}

// code for blur effect view for the side bar menu
struct effeV: UIViewRepresentable {
    var effect: UIVisualEffect? // fixing the blur effect
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { // making the view of blur
        UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { // function to update the blur view
        uiView.effect = effect
    }
}

// linking with Helper Functions
func recmUs(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) { // code or function to provide suggestion function or feedback
    let generator = UIImpactFeedbackGenerator(style: style) // make haptic feeback maker
    generator.impactOccurred() // Trageting the feedback
}

struct ContentView_Previews: PreviewProvider { // link preview provider for the main content view
    static var previews: some View {
        ContentView() // previewing the content view
    }
}
