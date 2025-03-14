import SwiftUI // Importing the UI of swift

// Begin the user login section
struct UserLogin: View { // Setting Several variables states
    @State private var email = "" // Stores the email of the user
    @State private var password = "" // Keep the password of user
    @State private var mesDispla = "" // shows error or store informational data
    @State private var wannaRegister = false // Nav contopller for register the user
    @State private var okLogi = false // nav to main app screen after successful
    
    // Using the observed object to manage the shared data from data manager like authentication
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        NavigationView { // bring nav view to wrap up
            ZStack { // layer backround and content
                // beginm backgropund section
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]), // adjust different graident color for better visulation
                    startPoint: .topLeading, // add the direction or way of graident
                    endPoint: .bottomTrailing // add endpoint in bottm side
                )
                .edgesIgnoringSafeArea(.all) // expand the edge of the screen
                
                // Major content are here
                VStack(spacing: 19) { // add vertical stack between differnet componenets
                    // Title of login user
                    Text("User Login") // title messgae
                        .font(.system(size: 34, weight: .bold, design: .rounded)) // adding the custom font for better visual
                        .foregroundColor(.white) // make the text color as white
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5) // adjust the text shadow
                        .padding(.top, 39) // set padding in top side
                    
                    // insert  the Email section
                    TextField("Email", text: $email) // text part to write email
                        .padding()// adjust  the required padding
                        .background(Color.white.opacity(0.2)) // making semi tranp and add color
                        .cornerRadius(10) // fixing the radius or border
                        .keyboardType(.emailAddress) // fix keyboard type to email
                        .autocapitalization(.none)// Not enabling the auto capatial
                        .foregroundColor(.white) // add white as text color
                    
                    // Insert Password Section
                    SecureField("Password", text: $password) // text part to write password
                        .padding() // adjust  the required padding
                        .background(Color.white.opacity(0.2)) // making semi tranp and add color
                        .cornerRadius(10) // fixing the radius or border
                        .foregroundColor(.white) // add white as text color
                    
                    // Display the error message logic
                    if !mesDispla.isEmpty { // when the mesDisplay is no nil then show the erroe message
                        ErmSm(text: mesDispla) // using the reusable componenets
                    }
                    
                    // Logic for login button
                    Button(action: partLog) { // Action to get the icon
                        HStack {
                            Text("LOGIN") // login message
                                .font(.headline) // adding the bold font
                                .frame(maxWidth: .infinity) // making the button in full width
                        }
                        .padding() // add necessay padding
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)) // adding the custom gradient for background
                        .foregroundColor(.white) // text is in white color
                        .clipShape(RoundedRectangle(cornerRadius: 14)) // making the rounded corners and add radius
                        .shadow(color: Color.blue.opacity(0.4), radius: 11, x: 0, y: 11) // declare the shadow
                    }
                    .padding(.vertical, 19) // vertical side padding
                    
                    // adding the link of register user
                    HStack {
                        Text("Don't have an account?") // text display if the user don't have aacount
                            .foregroundColor(.white) //text color as white
                            .font(.subheadline) // font size as subheading
                        
                        NavigationLink(destination: UserRegister(), isActive: $wannaRegister) { // if the register user is true then navigate top user Register panel
                            Text("Register Here") // Text with link
                                .font(.subheadline) // implement size of font
                                .fontWeight(.bold) // add bold weight
                                .foregroundColor(.white) // text color as white
                                .underline() // used uderline for clickable
                        }
                    }
                    
                    Spacer() // throw content at top side of screen
                }
                .padding(.horizontal, 29) // adjust the padding in horizontal side
            }
            .navigationBarHidden(true) // hiding the nav bar on screen
            .background(
                NavigationLink(destination: UserView(), isActive: $okLogi) { // move to user view of okLogi is true
                    EmptyView() // hidden nav  link
                }
            )
        }
    }
    
    // add function to manage the login section
    private func partLog() {
        if valFir() { // validate the user input parts
            if dataManager.useVal(email: email, password: password) { // add the validate user data
                okLogi = true // go to main section of app screen
            } else {
                mesDispla = "Invalid email or password." // if the data are invalid then display the message
            }
        }
    }
    // Add function to verify the input section
    private func valFir() -> Bool {
        if email.isEmpty || password.isEmpty { // verify if any part is nil
            mesDispla = "Please fill in all required fields." // throw and set the error messgae
            return false
        }
        return true // if the validation is success
    }
}


// using the reusable elements
struct ErmSm: View {
    let text: String // fix text for error message
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill") // adding the warning image
                .foregroundColor(.red) //add the red color of that image
            Text(text) // text for error message
                .font(.caption) // making the font size small
                .foregroundColor(.red) // text in red color
        }
        .padding(10) // adding the padding
        .background(Color.red.opacity(0.1)) // light red color adding in background
        .cornerRadius(8) // add trhe rounded corners
    }
}

// User 
struct UserLogin_Previews: PreviewProvider {
    static var previews: some View {
        UserLogin() // previwing the user login view
    }
}
