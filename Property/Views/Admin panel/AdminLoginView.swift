import SwiftUI // Importing Swift UI

struct AdminLoginView: View { // Main login screen for Admin side
    @State private var username: String = "" // storing the username input
    @State private var password: String = "" // password input store here
    @State private var sucLog = false // successful login tracking
    @State private var notifiAl = false // state to display login failure alert
    
    @Environment(\.presentationMode) var presentationMode // For back button using enviroment
    
    let AdUser = "Admin" // defining the admin username
    let adPass = "Admin123" // Defining the admin password
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // combination of background gradient colors
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(07), Color.purple.opacity(0.8)]), // combination color
                    startPoint: .topLeading, // begining top leading
                    endPoint: .bottomTrailing // ending top leading
                )
                .edgesIgnoringSafeArea(.all) // filling the screen side
                
                //  start the Main Content view
                ScrollView { // manking content scorable
                    VStack(spacing: 21) { // add spacing between
                        // Back Button for navigation
                        HStack { // add horizontal stack
                            Button(action: {
                                presentationMode.wrappedValue.dismiss() // Go back and make dismiss
                            }) {
                                Image(systemName: "arrow.left") // button arrow back
                                    .font(.title) // add font title
                                    .foregroundColor(.white) // make text as white color
                                    .padding() // add padding
                            }
                            Spacer() // make space in between
                        }
                        .padding(.top, geometry.safeAreaInsets.top) // setting for the safest area
                        
                        // Show the main title of login panel
                        Text("Admin Login")
                            .font(.system(size: geometry.size.width > 599 ? 41 : 31, weight: .bold, design: .rounded)) // combine of graident color
                            .foregroundColor(.white) // add text color
                            .padding(.top, 21) // add top padding as 21
                        
                        //  Input for Username Field
                        cstMs(placeholder: "Username", text: $username, iconName: "person.fill") // declare the icon and placeholder
                            .frame(width: geometry.size.width * 0.8) //  fixing the 80% of screen width
                        
                        // Input the Password Field
                        cstMs(placeholder: "Password", text: $password, iconName: "lock.fill", isSecure: true) // declare the icon and placeholder for password
                            .frame(width: geometry.size.width * 0.8) // 80% of screen width
                        
                        // Login Button perform login action
                        ButtonCus(title: "Login", backgroundColor: .blue, action: { // show title for login and add color
                            if username == AdUser && password == adPass { //  Adding  the 80% of screen width
                                sucLog = true // show successful login
                            } else {
                                notifiAl = true // if not successful then show the alert fail
                            }
                        })
                        .frame(width: geometry.size.width * 0.8) // setting 80% of screen width
                        .padding(.top, 20) // add padding at top side
                        
                        // Navigate to landlord login screen
                        NavigationLink(destination: LandlordLogin(onSuccess: {})) { // link to move landlord login
                            Text("Go to Landlord Login") // message to go landlord login
                                .font(.headline) // set font
                                .foregroundColor(.white) // add text color
                                .padding() // fix padding
                                .frame(maxWidth: .infinity) // declare the max width
                                .background(Color.green) // add BG color
                                .cornerRadius(10) // making the corner radius
                                .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 5) // setting several colors for shadow
                        }
                        .frame(width: geometry.size.width * 0.8) // setting 80% of screen width
                        
                        // Move to user login panel
                        NavigationLink(destination: UserLogin()) { // link to go user login
                            Text("Go to User Login") // show message towards user login
                                .font(.headline) // add font size
                                .foregroundColor(.white) // set text color
                                .padding() // fix necessay padding
                                .frame(maxWidth: .infinity) // inilize max width
                                .background(Color.orange) // set BG color as orange
                                .cornerRadius(10) // make the radius corner as well
                                .shadow(color: Color.orange.opacity(0.3), radius: 5, x: 0, y: 5) // add multiple color combination for shadow
                        }
                        .frame(width: geometry.size.width * 0.8) // setting more than 80% of screen width
                        
                        Spacer() // add space in between
                    }
                    .frame(width: geometry.size.width) // set the full width
                    .padding(.horizontal, 20) // horizontal padding to the vertical stack
                }
            }
            .navigationBarHidden(true) // Hiding the nav bar for this view
            .background(
                NavigationLink(destination: AdminDashboardView(), isActive: $sucLog) { // Navg link to Admin Dashboard
                    EmptyView() // An invisible view as a placeholder for the nav
                }
            )
            .alert(isPresented: $notifiAl) { // present an show alert when notifiAl is true
                Alert(
                    title: Text("Login Failed"), // add title of the alert
                    message: Text("Incorrect username or password."), // show alertwhen the alert
                    dismissButton: .default(Text("OK")) // Dismissing the alerting
                )
            }
        }
    }
}

// Customing  Text Field (Fragment/Reusable Component)
struct cstMs: View {
    let placeholder: String // placeholder text field
    @Binding var text: String // binding and store entered field
    let iconName: String // name of the icon to show in text field
    var isSecure: Bool = false // Determines if the text field is secure for password
    
    var body: some View { // Defines the body of the custom part
        HStack { // add horizontal stack
            Image(systemName: iconName) // show the icon
                .foregroundColor(.gray) // add the icon color
                .padding(.leading, 10) // add padding edge to icon
            
            if isSecure { // text field must be secure
                SecureField(placeholder, text: $text) // for password input secure field
                    .padding() // add necessary padding
            } else {
                TextField(placeholder, text: $text) // non secure input
                    .padding() // set padding around the text field
            }
        }
        .background(Color(.systemBackground)) // set the BG color
        .cornerRadius(10) // Making the radius of corner
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5) // making the shadow by adding differnet colors
    }
}

struct AdminLoginView_Previews: PreviewProvider { // Preview provider for the admin login
    static var previews: some View { // Defining the content of preview
        AdminLoginView() // adding this in Canvas 
    }
}
