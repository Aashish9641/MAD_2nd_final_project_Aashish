import SwiftUI // Importing teh Swift for Building UI

struct CreateLandlordView: View { // create or editing the landlord
    @Binding var viewLordsh: Bool // using binding control for visiblity
    @ObservedObject var dataManager: DataManager // add observed object to manage information
    @Binding var modifyLord: Landlord? // storing the landlord begin updated
    
    @State private var name = "" // setting the state variable for name of landlord
    @State private var email = "" // setting the state variable for email of landlord
    @State private var phone = "" // setting the state variable for phone  of landlord
    
    // Adding Custom color scheme
    private let mainVc = Color(red: 0.12, green: 0.38, blue: 0.52) //  settiong Deep Blue color
    private let subMa = Color(red: 0.91, green: 0.93, blue: 0.97) // Light Gray color added
    private let AGM = Color(red: 0.21, green: 0.61, blue: 0.87) // setting Sky Blue
    
    var modifying: Bool { // updating the exising landlordf
        modifyLord != nil // it returns ture if modify is not nil
    }
    
    var body: some View { // Defining the body
        NavigationView { // wrapping the nav view
            VStack(spacing: 24) { // add space in vertical stack
                // Form section here
                VStack(spacing: 20) { // add20 points spacing in vertical stack
                    csField(icon: "person.fill", placeholder: "Landlord Name", text: $name) // adding the custome text part for landlord name
                    csField(icon: "envelope.fill", placeholder: "Email Address", text: $email) // adding the custome text part for landlord email
                    csField(icon: "phone.fill", placeholder: "Phone Number", text: $phone) // adding the custome text part for landlord phone
                }
                .padding(.horizontal) // add padding in horizontal side
                .padding(.top, 24) // add padding in top side
                
                // code for Action Button
                Button(action: partSav) { // button for save and upadte
                    Text(modifying ? "Update Landlord" : "Add Landlord") // button for add and update
                        .font(.headline) // add style font
                        .frame(maxWidth: .infinity) // make the button in full width
                        .padding() // add necessay padding
                        .background(LinearGradient(gradient: Gradient(colors: [mainVc, AGM]), // add multiple gradient color for each
                                    startPoint: .leading,
                                    endPoint: .trailing)) // add the graident BG color
                        .foregroundColor(.white) // make text color as white
                        .cornerRadius(12) // making rounder the button corner
                        .shadow(color: mainVc.opacity(0.3), radius: 8, y: 4) // add multiple shadow
                }
                .padding(.horizontal) // set padding in horiozontal side
                
                Spacer() // bring the content in upside
            }
            .background(subMa.edgesIgnoringSafeArea(.all)) // add BG bcolor for whole view
            .navigationTitle(modifying ? "Edit Landlord" : "New Landlord") // add the title for nav mode
            .navigationBarTitleDisplayMode(.inline) // show the inline title
            .toolbar { // tool bar items
                ToolbarItem(placement: .navigationBarTrailing) { // save buttons on trailing side panel
                    Button("Save") { partSav() } // action for save button
                        .foregroundColor(mainVc) // add button color
                        .disabled(name.isEmpty || email.isEmpty || phone.isEmpty) // disable if the fields are nil
                }
                
                ToolbarItem(placement: .navigationBarLeading) { // cancel button action in leading
                    Button("Cancel") { viewLordsh = false } // perform the cancel button
                        .foregroundColor(mainVc) // add button color for cancel
                }
            }
        }
        .onAppear(perform: dataAlred) // populates fields if modification an existing landlords
    }
    
    // Adding various Custom Text Field elements
    struct csField: View { // Set reusable Custom part element
        let icon: String // icon for text field
        let placeholder: String // add placeholder to text part
        @Binding var text: String // binding to store the input text
        
        var body: some View { // Defining the body part
            HStack(spacing: 12) { // add the horizontal stack for text and icon
                Image(systemName: icon) // show the icon
                    .foregroundColor(.gray) // add the color as gray
                    .frame(width: 20) // add the width of icon
                
                TextField(placeholder, text: $text) // text part for user input
                    .foregroundColor(.primary) // add text color
            }
            .padding() // set padding
            .background(Color.white) // add BG color
            .cornerRadius(10) // making the corner of button
            .shadow(color: Color.black.opacity(0.05), radius: 3, y: 2) // add shadow by using several colors
        }
    }
    
    private func dataAlred() { // function to populate sections if modify an existing landlord
        guard let landlord = modifyLord else { return } // vferify if a landlord is being updated
        name = landlord.name // name section populated
        email = landlord.email // email section populated
        phone = landlord.phone // phone  section populated
    }
    
    private func partSav() { // function to validate and saving the landlord
        guard !name.isEmpty && !email.isEmpty && !phone.isEmpty else { return } // make sure the fields are not nil
        dolorDs() // calling the save function
    }
    
    func dolorDs() { // function for saving or update the landlord
        if modifying, let landlord = modifyLord { // update an exising landlord remins same
            let updatedLandlord = Landlord( // make an modified landlord object
                id: landlord.id, // make the id same
                name: name, // modified the name
                email: email, // modify the email
                phone: phone, // modified the phone as well
                properties: landlord.properties // make teh properties as it is
            )
            dataManager.lordUpdate(updatedLandlord) // modify the landlord in data manager
        } else {
            let addOne = Landlord( // make the new landlord object
                name: name, // fix name
                email: email, // set email address
                phone: phone, // set phone number
                properties: [] // Declear with no properties
            )
            dataManager.lordAdd(addOne) // adding the landlord to data manager
        }
        viewLordsh = false // clear the view 
    }
}
