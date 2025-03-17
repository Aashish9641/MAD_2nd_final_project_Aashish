import SwiftUI // Importing the Swift UI

struct AdminDashboardView: View { // Here in the admin panel begins
    @ObservedObject private var dataManager = DataManager.shared // using observed object to tack data from datamanager
    @State private var viewLordsh = false // controlling the landlord creating
    @State private var lordPick: Landlord? = nil // storing the selction landlord
    @State private var removeLamd: Set<UUID> = [] // choosing the landlord for deletion
    
    // Adding the multiple Custom Color Scheme
    private let pmCm = Color(red: 0.11, green: 0.37, blue: 0.53) //  adding the Deep Blue
    private let smCm = Color(red: 0.92, green: 0.94, blue: 0.96) // Setting Light Gray
    private let amcm = Color(red: 0.20, green: 0.60, blue: 0.86) //  Fixing Sky Blue
    private let dcCm = Color(red: 0.86, green: 0.22, blue: 0.27) //  Adding Coral Red color
    private let SccCm = Color(red: 0.22, green: 0.65, blue: 0.53) // Adding Teal Green
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) { // adding spacing the vertical side
                // Select All Button and manage choose and unchoose
                if !dataManager.landlords.isEmpty {
                    HStack { // horizontal stack
                        Button(action: allpickToh) { // adding the button
                            HStack(spacing: 8) { // add horizontal stack
                                Image(systemName: removeLamd.count == dataManager.landlords.count ? // add images for deletion
                                     "checkmark.circle.fill" : "circle") // add icon of circle
                                    .font(.system(size: 18)) // add the font size
                                
                                Text(removeLamd.count == dataManager.landlords.count ?
                                     "Deselect All" : "Select All") // text for the button
                                    .font(.subheadline) // add text font
                            }
                            .foregroundColor(removeLamd.isEmpty ? pmCm : .primary) // add text color
                            .padding(.vertical, 10) // set vertical padding
                            .padding(.horizontal, 15) // add horizontal padding
                            .background(Color(.systemBackground)) // add button BG color
                            .cornerRadius(10) // making rround the corner s
                            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1) // using multiple color for better shadow
                        }
                        Spacer() // bring the space to top
                    }
                    .padding(.horizontal) // add padding in horizontal side
                    .padding(.vertical, 12) // set padding in vertical side
                    .background(Color(.systemBackground)) // add the BG color
                    .shadow(color: Color.black.opacity(0.05), radius: 2, y: 2) // adding the shadow
                }
                
                // Here are the List of Landlords
                List { // list to show landlords
                    ForEach(dataManager.landlords) { landlord in // Iterate through lanlord section
                        LandlordRow( // add custom row ro each landlords
                            landlord: landlord, // padd the landlord information
                            hasChoose: removeLamd.contains(landlord.id), // verify if the landlord is choosen
                            selecOn: { pickToog(for: landlord.id) }, // action for toogle choosing
                            modifyO: { // action to update the landlord
                                lordPick = landlord // set the choosen landlord -
                                viewLordsh = true // dispaly the landlord view
                            }
                        )
                        .listRowInsets(EdgeInsets(top: 13, leading: 5, bottom: 13, trailing: 17)) // add the padding in row
                        .listRowBackground(Color.clear) // add row background to clear
                    }
                }
                .listStyle(PlainListStyle()) // user plain style text
                .background(smCm) // setting the list BG color
                
                // Removing  Choosing  Button
                if !removeLamd.isEmpty { // verify if the any lanlord is choosen or not
                    Button(action: deletelordPicks) { // button to remove landlord
                        HStack { // horizontal stack
                            Image(systemName: "trash") // using the icon for trash
                            Text("Delete Selected (\(removeLamd.count))") // text for choosen landlords
                        }
                        .frame(maxWidth: .infinity) // make the button with full width
                        .padding() // add the required padding
                        .background(dcCm) // set button BG color
                        .foregroundColor(.white) // add the text color
                        .cornerRadius(12) // make the corner raidus
                        .shadow(color: dcCm.opacity(0.3), radius: 8, x: 0, y: 4) // add the shadow by using color
                    }
                    .padding() // add padding in button
                }
                
                // Buttong to Add Landlord
                Button(action: { // button to add new landlord
                    lordPick = nil // reset the choosen landlord
                    viewLordsh = true // modification view
                }) {
                    HStack { // horizontal stack
                        Image(systemName: "plus.circle.fill") // add the plus icon
                        Text("Add Landlord") // text for add icon
                    }
                    .frame(maxWidth: .infinity) // make the button full width
                    .padding()// add necessary padding
                    .background(SccCm) // add button BG color
                    .foregroundColor(.white) //add text color
                    .cornerRadius(12) // making rounde thge corner
                    .shadow(color: SccCm.opacity(0.3), radius: 8, x: 0, y: 4) // add shadow
                }
                .padding() // add padding around the button
            }
            .background(smCm.edgesIgnoringSafeArea(.all)) // add the BG color for whole view
            .navigationTitle("Admin Dashboard") // setting the Nav title
            .sheet(isPresented: $viewLordsh, onDismiss: { // for landlord modification
                lordPick = nil // Reset the choosen landlord when the sheet is unavilabvle
            }) {
                CreateLandlordView( // view for makeing or updating a landlord
                    viewLordsh: $viewLordsh, // Biniding the control sheet
                    dataManager: dataManager, // passing the data manager
                    modifyLord: $lordPick  // for modify pass teh choosen landlord
                )
            }
        }
    }
    
    // Using Toggle for  Select All
    func allpickToh() { // function to choose all and unselect all
        if removeLamd.count == dataManager.landlords.count { // check if all landlord are choosen
            removeLamd.removeAll()
        } else {
            removeLamd = Set(dataManager.landlords.map { $0.id }) // un selected all landlord
        }
    }
    
    //Using  Toggle Selection for a one  Landlord
    func pickToog(for id: UUID) { // Function to tootle choosing for a single landlord
        if removeLamd.contains(id) { // check if the landlord is choosen already
            removeLamd.remove(id) // diselect the landlord
        } else {
            removeLamd.insert(id) // choose teh landlod
        }
    }
    
    // remove  chose Landlords
    func deletelordPicks() { // function to remove the choosen landlord
        for id in removeLamd { // delete through the id
            dataManager.lordRemove(id: id) // Remove landlord from data manager operation
        }
        removeLamd.removeAll() // clear the choosing set 
    }
}
