import SwiftUI // importing teh swift UI

@available(iOS 13.0, *) // makesure  compatibility with iOS 13 and latest version
struct LandlordLogin: View { // structure of login landlord side
    @ObservedObject private var dataManager = DataManager.shared // connect shared instance of data manager panel
    @State private var username = "" // for user input add state variable
    @State private var email = "" // for user email add state variable
    @State private var bugMes = "" // state part of error message
    @State private var golGin = false // manage the navigation after successful login
    @State private var lordOk: Landlord? = nil // store the landlord logged
    
    // adding different custom color scheme
    private let pmCol = Color(red: 0.11, green: 0.37, blue: 0.53) // combination of Deep Blue
    private let secmaiColor = Color(red: 0.92, green: 0.94, blue: 0.96) // added light gray color
    private let goUcss = Color(red: 0.23, green: 0.64, blue: 0.53) // used teal green fopr better visiblity
    
    var onSuccess: () -> Void // it does callback for successful login
    
    var body: some View {
        NavigationView { // begin the nav bar part
            VStack(spacing: 24) { // login screen vertical stack
                // Header begins here
                VStack(spacing: 8) { // add spacing as 8
                    Image(systemName: "person.crop.circle.badge.checkmark") // addthe header icon of circle
                        .font(.system(size: 39)) // add the size of icon
                        .foregroundColor(pmCol) // add the color to icon
                    
                    Text("Landlord Login") // Header text for landlord login side
                        .font(.largeTitle) // verify the font size
                        .fontWeight(.bold) // making the text bold
                        .foregroundColor(.primary) // add text color
                }
                .padding(.top, 40) // add padding in top side
                
                // Function to begin the form fill
                VStack(spacing: 16) { // add vertical stack for fill the form
                    fieldCst(symbo: "person.fill", holder: "Username", text: $username) // this is user name section
                    fieldCst(symbo: "envelope.fill", holder: "email", text: $email) // user email section
                        .keyboardType(.emailAddress) // add keyboard to email address
                        .autocapitalization(.none) // not enable the auo capital
                }
                .padding(.horizontal) // add padding in horizontal side
                
                // Throw the Error Message
                if !bugMes.isEmpty { // if the fields are not empty
                    Text(bugMes)
                        .font(.subheadline) // set the size of font
                        .foregroundColor(.red) // add the color
                        .transition(.opacity) // add fade feature
                }
                
                // function to Login Button action
                Button(action: login) { // to triggter the login action
                    HStack { // add horizontal stack
                        Image(systemName: "arrow.right.circle.fill") // button icon for login
                        Text("Login") // add the text button
                            .fontWeight(.semibold) // sec weight font
                    }
                    .frame(maxWidth: .infinity) // make the button full width
                    .padding() // adding padding
                    .background(LinearGradient(gradient: Gradient(colors: [pmCol, goUcss]), startPoint: .leading, endPoint: .trailing)) // setting the required background color
                    .foregroundColor(.white) // setting the color
                    .cornerRadius(11) // making the rounded corner of button
                    .shadow(color: pmCol.opacity(0.4), radius: 7, y: 5) // fix shadow
                }
                .padding(.horizontal) // add padding in horizontal side
                
                Spacer() // bring content at top side
            }
            .background(secmaiColor.edgesIgnoringSafeArea(.all)) // set background color
            .navigationTitle("Landlord Login") // set nav title for login the landlord
            .navigationBarTitleDisplayMode(.inline) // make the title in visual mode
            .onAppear {
                // Resetting the view when it is appear
                username = "" // field of username
                email = "" // email section
                bugMes = "" // error message
            }
            .background( //for background operation
                Group {
                    if let landlord = lordOk { // verify whether the landlord is logged in or not
                        if #available(iOS 15.0, *) { // verify the latest IOS
                            NavigationLink( // add the link of nav
                                destination: LandlordDashboard(landlord: landlord), // redirect to ladlord panel
                                isActive: $golGin // performing the control navigation
                            ) { EmptyView() } // nil part
                        } else {
                            // in case of not avaibale of IOS Fallback for earlier versions
                            if #available(iOS 15.0, *) {
                                NavigationLink( // add nav link of landlord dashboard
                                    destination: LandlordDashboard(landlord: landlord), // if it successful go to landlord dashboard page
                                    isActive: $golGin // verification whether it is active or not
                                ) { EmptyView() } // empty section
                            } else {
                                // go to pervious version
                            }
                        }
                    }
                }
            )
        }
    }
    
    // adding multiple components for text field
    struct fieldCst: View {
        let symbo: String // add icon of required field
        let holder: String // add place holder text
        @Binding var text: String // add binding for the text part
        
        var body: some View {
            HStack(spacing: 12) { // add horizontal stack for padding and icon
                Image(systemName: symbo) // add the icon
                    .foregroundColor(.gray) // add color as gray
                    .frame(width: 20) // setting the width of icon
                
                TextField(holder, text: $text) // Text section
                    .foregroundColor(.primary) // add the primary color in text
            }
            .padding() // add the required padding
            .background(Color.white) // add text BG color
            .cornerRadius(10) // make the radius corner
            .shadow(color: Color.black.opacity(0.05), radius: 3, y: 2) // add shadow features
        }
    }
    
    // Login Action function
    private func login() {
        if username.isEmpty || email.isEmpty { // checking the validates fields
            bugMes = "Please fill in all fields" // if the fields are nil then show this error
            return
        }
        
        if dataManager.lordValidation(username: username, email: email) { // verifying the crendential of landlord
            lordOk = dataManager.lordGet(username: username, email: email) // get or fetching the landlord
            golGin = true // It triggers the nav  bar
            onSuccess() // calling  the onSuccess closure
        } else {
            bugMes = "This is Invalid Username or Email" // if this field are nil then show the error
        }
    }
}
