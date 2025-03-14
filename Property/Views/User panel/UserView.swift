import SwiftUI // Importing the swift part

// this is main user view side
struct UserView: View {
    @ObservedObject private var dataManager = DataManager.shared // adding the observing main data mangaer
    @State private var btnLogout = false // stating the dispaly or hide the buttoin
    @State private var outLog = false // code to handle the navigation ot main login screen
    
    // Feteching the user logged details
    private var inUse: User? {
        dataManager.users.first // Assuming the first user is the logged-in user
    }
    
    // making the username as default
    private var username: String {
        inUse?.name ?? "Guest" // it return the username of guest
    }
    
    var body: some View {
            VStack(spacing: 0) { // adding the vertical stack for layout
                // this is welcome header section panel
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hey, Welcome") // adding the welcome message
                            .font(.subheadline) // initlize font size
                            .foregroundColor(.gray) // settting color as gray
                        Text("@\(username)") // show the username of loggedon user
                            .font(.title2.bold()) // making bold and expand font
                            .foregroundColor(Color.blue) // fixing the username color as blue
                    }
                    
                    Spacer() // adding the space push item and place as left
                    
                    // to dispaly the first letter of username for better animation
                    Button(action: {
                        withAnimation {
                            btnLogout.toggle() // adding the button visibilye with animation
                        }
                    }) {
                        Text(String(username.first ?? "U")) // display the first letter of username for better visiblity
                            .font(.title.bold()) // fixigin the bold font
                            .foregroundColor(.white) // add white color
                            .frame(width: 49, height: 49) // fixing the size for button
                            .background(Color.purple) // setting purple color
                            .clipShape(Circle()) // make the button in circular shape
                            .shadow(color: Color.purple.opacity(0.3), radius: 4, x: 0, y: 4) // declare the shadow effect to button
                    }
                    .overlay(
                        // logout button dispaly when btn is true add function
                        VStack {
                            if btnLogout {
                                Button(action: {
                                    outLog = true // Trigger logout when clicking button
                                }) {
                                    Text("Logout") // set label for the button
                                        .font(.subheadline.bold()) // add style font
                                        .foregroundColor(.white) // white as background color
                                        .padding(.horizontal, 15) // adding paddiing in horizontal side
                                        .padding(.vertical, 7) // padding in vertical side
                                        .background(Color.red) // fixing the background color as red
                                        .cornerRadius(10) // adding the radius as red
                                        .shadow(color: Color.red.opacity(0.2), radius: 4, x: 0, y: 4)// red color for shadow animation
                                }
                                .transition(.opacity) // adding the fade animation for show and hide
                                .padding(.top, 7) // declare the top side padding
                            }
                        }
                        , alignment: .bottom // position the logout in bottin
                    )
                }
                .padding(.horizontal) // hoprizontal padding
                .padding(.top, 15) // adding top padding
                .padding(.bottom, 7) // for header bottom padding
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color(.systemGray6)]), // adding color combination for gradient
                        startPoint: .top, // begin gradient from upper level
                        endPoint: .bottom //end from the bottom level
                    )
                    .edgesIgnoringSafeArea(.top) // avoid teh safe ware from top level
                )
                
                // these are the list of propeties sections
                ScrollView {
                    VStack(spacing: 15) { // adding the spacing
                        ForEach(dataManager.properties, id: \.id) { property in
                            cardPropp(property: property) // show the propert card fearure for each added property
                                .padding(.horizontal) // adding the padding in hoprizontal side
                        }
                    }
                    .padding(.vertical)// added the padding in vertical side
                }
                .background(Color(.systemGray6)) // implement color as system ngreay in background
            }
            .navigationTitle("Available Properties") // this is title of navigation side bar
            .navigationBarTitleDisplayMode(.inline) // show the title in nav bar
            .toolbar {
                ToolbarItem(placement: .principal) { // fix toolbar title
                    Text("Available Properties") // title of the tool bar
                        .font(.title2.bold()) //add font size
                        .foregroundColor(.primary) // declare the primary color
                }
            }
            .navigationBarBackButtonHidden(true) // Hide the back button from the naviagiton bar
            .background(
                NavigationLink(destination: UserLogin(), isActive: $outLog) { // link of the navigation for logout patterns
                    EmptyView()// it happens since the nav bar programmitally
                }
            )
        }
    }



// adding the property card feature of user side
struct cardPropp: View {
    let property: Property // adding the required data for this
    
    @State private var reqCont = false  // code to handle requesting landlord
    @State private var textSuccess = false // code to dispaly success messnage after success
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) { // adding the spacing
            //  sohw the Property Address
            Text(property.address)
                .font(.headline) //add font style to headline
                .foregroundColor(.primary) // fixing the primary color
            
            // Property Description in prop view
            Text(property.description)
                .font(.subheadline)// set the font style
                .foregroundColor(.secondary) // adding the secondray color
                .lineLimit(2) // Limit description in  2 lines
            
            // Delcaration Property Price
            Text("NRP\(property.price, specifier: "%.2f")") // show the price added by landlord
                .font(.subheadline.bold()) // making the font
                .foregroundColor(Color.green) // add the green color price
            
            // adding the Contact Landlord Button
            Button(action: {
                reqCont = true // when the button is clicked dispaly the contact request
            }) {
                Text("Proceed to Contact Landlord") // labling teh title
                    .font(.subheadline.bold())// adding the font as bold
                    .foregroundColor(.white) // set color as white
                    .padding(.horizontal, 16) // add padding in horizontal
                    .padding(.vertical, 10) // add padding in vertifcal side
                    .frame(maxWidth: .infinity) // make this button exapand to fill the necessayr foprm
                    .background(Color.purple)// adding color as pruple
                    .cornerRadius(10) // set teh radius of the corner
                    .shadow(color: Color.purple.opacity(0.2), radius: 4, x: 0, y: 2)// declare the purple shadow effect to this
            }
            .padding(.top, 8)// align the padding as 8
        }
        .padding() // adding inside card
        .background(Color.white) // set background color
        .cornerRadius(12) // add rounder corner
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // set the shadow effect
        .sheet(isPresented: $reqCont) {
            conrVi(property: property, isShowing: $reqCont, textSuccess: $textSuccess) // dispaly the contact section after successful
        }
        .overlay(
            Group {
                if textSuccess {
                    showOk() // display the suceess messgae after
                        .transition(.opacity) // adding the fade suceess message
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                textSuccess = false // hiding the success message
                            }
                        }
                }
            }, alignment: .top // placing the sucess messgae at top the card
        )
    }
}

// Contact Request View  panel using fragment
struct conrVi: View { // Contacting  the request
    let property: Property // passing the details of property
    @Binding var isShowing: Bool // adding the control visibility
    @Binding var textSuccess: Bool // for successful submission
    
    @State private var cordinateText = "" // storing the messeage send  by user to landlord
    
    var body: some View {
        NavigationView { //Wrapping in the navigation view
            Form { // using container in form section
                Section(header: Text("Property Details").font(.headline)) { // Section indicate propety panel
                    Text(property.address) // show the address of prop
                        .font(.subheadline) // for subheadline font
                    Text(property.description) // show the descriptiomn of property
                        .font(.subheadline) // adding subheading font
                        .foregroundColor(.gray) // set forground color as gray
                    Text("$\(property.price, specifier: "%.2f")") // show the price of the property
                        .font(.subheadline.bold()) // making font bold
                        .foregroundColor(.green) // add the green cvolor
                }
                
                Section(header: Text("Your Message").font(.headline)) { // added header for input text message
                    TextEditor(text: $cordinateText) // multi line text input section
                        .frame(height: 149) // fixing height as 149
                        .overlay( // add overlay for border
                            RoundedRectangle(cornerRadius: 7) // add rounded corner for border side
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1) // add gary color with 0.3 opacity
                        )
                }
            }
            .navigationTitle("Contact to the Landlord") // Declare the title for contact part
            .toolbar { // for button navigation bar
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Wanna Cancel") { // adding the cancel option
                        isShowing = false // code to dismiss the view or action
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) { // bypass the button in trailing part
                    Button("Send") { // for sending button
                        wannCont() // fixing the contact request function part
                        isShowing = false // after sending dismisson
                        textSuccess = true // verify the successful
                    }
                    .disabled(cordinateText.isEmpty) // show the button if the message sent
                }
            }
        }
    }
    
    private func wannCont() { // function to contact part
        // adding  sending a contact request to landlords
        print("Contact request sent for property: \(property.address)") // declare the porperty address
        print("Message: \(cordinateText)") //Here logs the message of username
    }
}

// Success Message View after sending request
struct showOk: View { // for successmessage visulization
    var body: some View {
        Text("Message Sent Successfully! we will contact you soon") // show the text of success message
            .font(.subheadline.bold()) // making it bold
            .foregroundColor(.white) // add the color as white
            .padding() // fixing the padding
            .background(Color.green) // green background color as green
            .cornerRadius(11) // set corner radius
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)  // for shadow purpose adding this
            .padding(.top, 17) // add the top side padding
            .transition(.opacity) // using opacity for transition
    }
}

// for Code canvas using user perviews
struct UserView_Previews: PreviewProvider {
    static var previews: some View { // perviewing the user panel
        UserView() // perview the user side 
    }
}
