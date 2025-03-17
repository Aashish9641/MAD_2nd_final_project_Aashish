import SwiftUI // importing the swift UI

@available(iOS 15.0, *) // make sure whether the IOS is 15 or latest
struct LandlordDashboard: View { // begin the landlord panel
    @ObservedObject private var dataManager = DataManager.shared // sharing the instance of data manager to operate the database
    let landlord: Landlord // add logged in landlord
    
    @State private var dispalyForm = false // controlling the state of showe form 
    @State private var chosePop: Property? = nil // view of property listing
    @State private var dispmessSuc = false // manage the state of success messgae
    @State private var smgScu = "" // store the success message
    @State private var bugGiver = false // manage the view of error message
    @State private var givemsgEr = "" // storing the error message
    
    @State private var choseDifff: Set<String> = [] // Tracking  choosen  properties for bacth perform
    @State private var activeModel = false // inorder to operate the batch used toogle part
    
    // Combintaion of Custom Color Scheme manage
    private let ColorP = Color(red: 0.11, green: 0.37, blue: 0.53) //  adding the Deep Blue
    private let spM = Color(red: 0.92, green: 0.94, blue: 0.96) //  setting tyhe Light Gray color
    private let aspM = Color(red: 0.20, green: 0.60, blue: 0.86) // setting Sky Blue color
    private let dspM = Color(red: 0.86, green: 0.22, blue: 0.27) // added Red for coral part
    private let sspM = Color(red: 0.22, green: 0.65, blue: 0.53) // adding  Green color scheme
    
    @Environment(\.presentationMode) var presentationMode // For back navigation and presentation mode
    
    var body: some View { // begin here
        VStack(spacing: 0) { // added vertical stack and spacing
            // Header begins here
            HStack {
                //  added Back Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Adding the nav bar
                }) {
                    Image(systemName: "chevron.left") // add the icon
                        .font(.title2) // set the sixe of icon
                        .foregroundColor(.white) // add icon color
                }
                
                Text("My Properties") // Header title for displaying the properties
                    .font(.title2.bold()) // set font size
                    .foregroundColor(.white) // add the color
                
                Spacer() // bring elements to top side
                
                // Add Property Button action
                Button(action: {
                    chosePop = nil // Reset the choosen property
                    dispalyForm = true // display the form of property
                }) {
                    Image(systemName: "plus.circle.fill") // Adding the icon
                        .font(.title) // add the icon size
                        .foregroundColor(.white) // add icon color
                }
                
                // operation for choose and Disellction
                Button(action: {
                    activeModel.toggle() // used toogle for choosen mode
                    if !activeModel {
                        choseDifff.removeAll() // un select all when exiting select operation
                    }
                }) {
                    Text(activeModel ? "Cancel" : "Select") // Button text for respective operation
                        .font(.headline)// add the size of font
                        .foregroundColor(.white) // set text color as white
                }
                .padding(.leading, 11) // setting the necessary padding
            }
            .padding() // add padding as well
            .background(LinearGradient(gradient: Gradient(colors: [ColorP, aspM]), startPoint: .leading, endPoint: .trailing)) // connection of grident background color
            
            // Select All/Deselect All Buttons make it visible while choosen
            if activeModel {
                HStack { // add horizontal stack
                    Button(action: {
                        if choseDifff.count == dataManager.propG(for: landlord.id).count { // unselecting all
                            choseDifff.removeAll() // Disellcting  all the properties
                        } else {
                            // Select all operation for remove and update
                            choseDifff = Set(dataManager.propG(for: landlord.id).map { $0.id })
                        }
                    }) {
                        Text(choseDifff.count == dataManager.propG(for: landlord.id).count ? "Deselect All" : "Select All") // adding the button text for slection and not select
                            .font(.subheadline.bold())// add font size
                            .foregroundColor(ColorP) // set text color
                            .padding(.vertical, 8) // add padding in vertical side
                            .padding(.horizontal, 12) // set padding in horizontal side
                            .background(Color(.systemBackground)) // Set BG color
                            .cornerRadius(8) // round the button radius
                            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1) // Add the necessary shadow
                    }
                    
                    Spacer() // bring or push componenets in top side
                    
                    if !choseDifff.isEmpty { // selction if the part is nil
                        Button(action: {
                            // remove the choosen  properties
                            for propertyId in choseDifff {
                                dataManager.propRemove(propertyId, for: landlord.id) // Remove the property
                            }
                            choseDifff.removeAll() // make it clear the choosen part
                            smgScu = "Properties removed successfully!" // show message if the delete successful
                            dispmessSuc = true // Dispaly the Successful message
                        }) {
                            Text("Delete Selected") // text for button
                                .font(.subheadline.bold()) // add font size and weight part
                                .foregroundColor(dspM) // add text color
                                .padding(.vertical, 8) // set padding in vertical panel
                                .padding(.horizontal, 12) // Adding the horizontal padding
                                .background(Color(.systemBackground)) // add the BG color
                                .cornerRadius(8) // make the border coner as8
                                .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1) // Combination of Colors or shadow
                        }
                    }
                }
                .padding(.horizontal) // add padding in horizontal side
                .padding(.vertical, 8) // vertical side padding as 8
                .background(spM) // also add the background color
            }
            
            // Listing the several properties
            List {
                ForEach(dataManager.propG(for: landlord.id), id: \.id) { property in
                    ppoeCa( // adding the propery card to operate multiple operation
                        property: property, // add property
                        gotCho: choseDifff.contains(property.id), // verify if the property is choosen or not
                        activeModel: activeModel, // passing the model state
                        onUpdate: {
                            chosePop = property // add property for modification
                            dispalyForm = true // show the property form
                        },
                        onDelete: { // operation for removing properties
                            dataManager.propRemove(property.id, for: landlord.id) // removing the properties
                            smgScu = "Property deleted successfully!" // success message after removing
                            dispmessSuc = true // dispaly the messsage
                        },
                        onSelect: { // choosing and unselecting property
                            if choseDifff.contains(property.id) {
                                choseDifff.remove(property.id) // unselect the property
                            } else {
                                choseDifff.insert(property.id) // choose  the properties
                            }
                        }
                    )
                    .listRowInsets(EdgeInsets()) // Delete the default list
                    .padding(.vertical, 8) // add padding in vertical side
                    .padding(.horizontal) // set padding in horizontal axis
                }
            }
            .listStyle(.plain) // using the plain style text format
            .refreshable { // add auto refresh function
                dataManager.objectWillChange.send() // it helps to refresh the data as well
            }
        }
        .sheet(isPresented: $dispalyForm) { // show the property form as a sheet format
            PropertyFormView( // Property form view
                showFor: $dispalyForm, // binding the control visiblity
                dataManager: dataManager, // operating the data manager 
                landlord: landlord, // adding the landlord action
                chooseProp: $chosePop, // binding for the choosen property
                messSuccess:$dispmessSuc, // binding for the control success message
                sucMsg: $smgScu, // storiong the su
                thrErr: $bugGiver, // control error message dispaly
                msgErr: $givemsgEr // binding store error message text
            )
        }
        .alert(isPresented: $bugGiver) { // show error if there is any issue
            Alert(title: Text("Error"), message: Text(givemsgEr), dismissButton: .default(Text("OK"))) // adding the alert configuraiotn and show message 
        }
        .overlay( // setting ovfgerlay for success message
            Group {
                if dispmessSuc { // verfiying the success message display
                    Text(smgScu) // using text for success message
                        .padding() // set the necessary padding
                        .background(sspM) // add BG color
                        .foregroundColor(.white) // add text color as white
                        .cornerRadius(10) // make the corner radius
                        .transition(.opacity) // using fade transition function
                        .onAppear { // if the message shows it triggers
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // waiting for 2 seconds for refresh
                                dispmessSuc = false // hidding the message
                            }
                        }
                }
            }, alignment: .top // bring alignmenet at top side
        )
    }
}

struct ppoeCa: View { // add custom property to show
    let property: Property // property to display
    let gotCho: Bool // check if the property is choosen
    let activeModel: Bool // enable the choosen mode
    let onUpdate: () -> Void // add the closure update part
    let onDelete: () -> Void // add the closure delete part
    let onSelect: () -> Void // add the closure choosen action 
    
    // Custom Color Scheme
    private let ColorP = Color(red: 0.11, green: 0.37, blue: 0.53) //Connection of  Deep Blue color
    private let spM = Color(red: 0.92, green: 0.94, blue: 0.96) //combination  Light Gray
    private let aspM = Color(red: 0.20, green: 0.60, blue: 0.86) // aadd sky blue color
    private let dspM = Color(red: 0.86, green: 0.22, blue: 0.27) // Coral Red color added
    private let sspM = Color(red: 0.22, green: 0.65, blue: 0.53) // Teal Green color added
    
    var body: some View {
        HStack(spacing: 16) { // in property details add horozontal axis space
            // Choosing  Checkbox (Visible in chosse Mode)
            if activeModel { // chceck if the select mode is active
                Button(action: onSelect) { // choosing button
                    Image(systemName: gotCho ? "checkmark.circle.fill" : "circle") // set checkbox for selection
                        .font(.title2) // setting the icon size
                        .foregroundColor(gotCho ? ColorP : .gray) // add the color of icon
                }
                .buttonStyle(PlainButtonStyle()) // using the plain button style
            }
            
            // Details of listing property
            VStack(alignment: .leading, spacing: 8) { // add vertical stack and space as 8
                Text(property.address) // adding the address of property
                    .font(.headline) // add the font size
                    .foregroundColor(.primary) // add the text color as primay
                
                Text(property.description) // Description of the property
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("NPR \(property.price, specifier: "%.2f")") // for pricing the property
                    .font(.subheadline.bold()) // making it bold and add font
                    .foregroundColor(sspM) // add the text color
            }
            
            Spacer() // add space to bring data at top side
            
            // Action Buttons operation
            if !activeModel { // check if the choosen mode in not active
                VStack(spacing: 8) { // add vertical stack for action button
                    // modification of  Button
                    Button(action: onUpdate) { // button for update
                        Text("Update") // update text
                            .padding(.horizontal, 12) // add required padding
                            .padding(.vertical, 8) // set vertical padding
                            .background(aspM) // fix the BG color
                            .foregroundColor(.white) // add the text color
                            .cornerRadius(8) // add corner radius
                    }
                    .buttonStyle(PlainButtonStyle()) // using the plain text
                    
                    // function to delete the property
                    Button(action: onDelete) { // Button for remove
                        Text("Delete") // text fore remove
                            .padding(.horizontal, 12)// add required padding in horizontal axis
                            .padding(.vertical, 8) // set vertical padding
                            .background(dspM) // fix the BG color
                            .foregroundColor(.white) // add the text color
                            .cornerRadius(8) // add the corner radius
                    }
                    .buttonStyle(PlainButtonStyle()) // making the plain text
                }
            }
        }
        .padding() // ADding the required padding
        .background(Color(.systemBackground)) // setting the system background color
        .cornerRadius(12) // add corner radius
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // fix the combination of color for shadoe
        .contentShape(Rectangle()) //  making the the shape of content in rectangel
    }
}
