import SwiftUI // importing the Swift UI

// For Register user view
struct UserRegister: View {
    @State private var name = "" // store the name of user
    @State private var email = "" // store the email of the user
    @State private var password = "" // store the passowrd
    @State private var passRight = "" // if the password match with this it stores the conform password
    @State private var throwEr = "" // to show the error it show the bugs
    @State private var mshowUs = false // set the success mesage
    @State private var gotoLogin = false // nav to login screen
    
    // Managing the shared data for register the user
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        ZStack { // back option
            //  adding the multiple Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.4, blue: 0.5), Color(red: 0.2, green: 0.4, blue: 0.7)]), // Declaration the various color in gradient
                startPoint: .topLeading, // fixing the direction of grident
                endPoint: .bottomTrailing // addoing the traling part at end point
            )
            .edgesIgnoringSafeArea(.all) // Expanding the edge side of screen for Better responsive
            
            // Here are the main contents
            VStack(spacing: 14) { // spacing in bettern 14
                // Title of the user register
                Text("User Register") // Register message for user
                    .font(.system(size: 35, weight: .bold, design: .rounded)) // adding the various custom font here for better visulization
                    .foregroundColor(.white) // making text color as white
                    .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4) // declare the text shadow
                    .padding(.top, 39) // adding top side padding as 39
                
                // Inseting the name field section
                TextField("Name", text: $name) // Name sectrion for register
                    .padding() // adding padding here in name field
                    .background(Color.white.opacity(0.3)) // add BG color and opacity as well
                    .cornerRadius(9)// add the corner radius as 9
                    .foregroundColor(.white) // add color white
                    .overlay( // initlize the border overalay
                        RoundedRectangle(cornerRadius: 10) // adjust the corner radius
                            .stroke(Color.white.opacity(0.5), lineWidth: 1) // adjustment of semi transparent border
                    )
                
                // Email section for register part
                TextField("Email", text: $email)
                    .padding() // add padding
                    .background(Color.white.opacity(0.3)) //Fix BG color and opacity
                    .cornerRadius(10) // adjust the radious corner
                    .keyboardType(.emailAddress) // fix keyboard type top email part
                    .autocapitalization(.none)// Decline the auto capitalization
                    .foregroundColor(.white) // adding the color as white
                    .overlay( // adjust the overlay for border
                        RoundedRectangle(cornerRadius: 10) //Add rounded corner triangle
                            .stroke(Color.white.opacity(0.5), lineWidth: 1) //adjustment the opacity
                    )
                
                // insert the password for register part
                SecureField("Password", text: $password) // Text field for password
                    .padding() // declare the padding
                    .background(Color.white.opacity(0.4)) // fix BG color and opacity
                    .cornerRadius(11)// adding the radius of corner
                    .foregroundColor(.white) // add color as white
                    .overlay( // fix overlay for corner side
                        RoundedRectangle(cornerRadius: 11) // add rounded corner radius
                            .stroke(Color.white.opacity(0.6), lineWidth: 1) // adjustment the opacity and color
                    )
                
                // Confirm Password Field
                SecureField("Confirm your Password", text: $passRight) // Text field side for confim the password
                    .padding() // Declare the padding
                    .background(Color.white.opacity(0.3)) // fix BG color and opacity
                    .cornerRadius(10) // adding the radius of corner
                    .foregroundColor(.white) // add color as white
                    .overlay( // fix overlay for corner side
                        RoundedRectangle(cornerRadius: 10) // add rounded corner radius
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)// adjustment the opacity and color
                    )
                
                // Function to throw the error messgae
                if !throwEr.isEmpty { // show error messgage iof ThrowEr is empty
                    ThrowEr(text: throwEr) // using the reuseable message elements
                }
                
                // Code to add the register button
                Button(action: sideReg) { // declare the action to target Register
                    HStack {
                        Text("REGISTER HERE") // Need to register her messgae
                            .font(.headline) // making the button bold
                            .frame(maxWidth: .infinity) // expand the button to full width
                    }
                    .padding() // adjust the padding for button
                    .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.3, green: 0.7, blue: 0.5), Color(red: 0.1, green: 0.7, blue: 0.7)]), startPoint: .leading, endPoint: .trailing)) // using the multiple custom function
                    .foregroundColor(.white) // execute the color as white and grident background
                    .clipShape(RoundedRectangle(cornerRadius: 14)) // making the rounded corner
                    .shadow(color: Color(red: 0.2, green: 0.6, blue: 0.7).opacity(0.2), radius: 11, x: 0, y: 10) // adding the shadwor for better visualtion
                }
                .padding(.vertical, 21) // adjust padding vertical as 21
                
                Spacer()// place teh content to top side
            }
            .padding(.horizontal, 29) // used horizontal padding for Vstack
        }
        // function to disaply messgae
        .alert(isPresented: $mshowUs) { // when the msShow is right show the message
            Alert(
                title: Text("Success"), //Fix the title of alert
                message: Text("Registration successful! You will be redirected to the login panel ."),// adding alert messgae after successful register
                dismissButton: .default(Text("OK")) {// add ok Button to udo the alert
                    gotoLogin = true // go to login page  after successful
                }
            )
        }
        .background(
            NavigationLink(destination: UserLogin(), isActive: $gotoLogin) {// When the login is true go to user Login
                EmptyView()// making not visible the link
            }
        )
        .navigationBarBackButtonHidden(true) // using hiding the back option logic
    }
    

    // Function to operate the register logic here
    private func sideReg() {
        if rightFie() { // need to validate the user input sections
            if dataManager.plusUse(name: name, email: email, password: password) { // try to attempt to Register the user
                mshowUs = true // Dispaly the success alert
            } else {
                throwEr = "provided enmail is  already exists." // If the mail is already exist show the message
            }
        }
    }
    
    // Function to verify the fields
    private func rightFie() -> Bool {
        if name.isEmpty || email.isEmpty || password.isEmpty || passRight.isEmpty { // Check if there is any nil fields
            throwEr = "Please fill in all the fields." // setting the error message
            return false // returning the false
        }
        
        if password != passRight { // Verify if the password match or not
            throwEr = "Passwords do not match." //adjust the error message
            return false
        }
        
        return true // validation has been passed
    }
}

// Setting the resuable elements here

struct ThrowEr: View {
    let text: String // for display the error message
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill") // adjust the icon of warning
                .foregroundColor(.red) // set color as red
            Text(text) // text for throw error messgae
                .font(.caption) // making the font size small
                .foregroundColor(.red) // adding the red color
        }
        .padding(10) // set padding as 10
        .background(Color.red.opacity(0.1)) // add the background color light red
        .cornerRadius(8) // fix corner raidus
    }
}

// Perview provide sections
struct UserRegister_Previews: PreviewProvider {
    static var previews: some View {// Perviwing the user Register view
        UserRegister() // user Register panel 
    }
}
