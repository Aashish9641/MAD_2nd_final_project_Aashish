import UIKit // importing the UIkit
import SwiftUI // importing swift UI
struct PropertyFormView: View { // introducing the swift UI view for add or edit property
    @Binding var showFor: Bool // using binding control for better visiblity form
    @ObservedObject var dataManager: DataManager // used observed to managing the data operations
    let landlord: Landlord // lanlord linked with property
    @Binding var chooseProp: Property? // binding choose property for editing
    @Binding var messSuccess: Bool  // Dispaly  the success message
    @Binding var sucMsg: String // Storing the success message
    @Binding var thrErr: Bool // Storing the error message
    @Binding var msgErr: String // error message text
     // storing the input
    @State private var address = "" // store or collect address input
    @State private var description = "" // store description input
    @State private var price = "" // store price input in number
    
    var editM: Bool { // checking if the form is modified mode or not
        chooseProp != nil // throw nil
    }
    
    // begin body of the view
    var body: some View {
        NavigationView { // nav var begin
            Form { // for to add the property
                TextField("Address", text: $address) // enter the address of property
                TextField("Description", text: $description) // set the description of property
                TextField("Price", text: $price) // add the numeric value of price
                    .keyboardType(.decimalPad) // used decimal numbering
                
                Button(action: propS) { // used button to submit the form( add or update )
                    Text(editM ? "Update Property" : "Add Property") // text for add or update the prop
                        .frame(maxWidth: .infinity) // set the width
                        .padding() // add the necessary padding
                        .background(Color.blue) // set color as blue
                        .foregroundColor(.white) // text color as white
                        .cornerRadius(10) // add corener radious as 10
                }
            }
            // using nav title for modify the property
            .navigationTitle(editM ? "Edit Property" : "Add Property") // Text for modification
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { // add cancel button in top right
                    Button("Cancel") { // text for cancel operation
                        showFor = false // hiding the form
                    }
                }
            }
            .onAppear { // when the view appears it hits
                if let property = chooseProp { // verify the prop is choosen or not for modify
                    address = property.address // fill address part with property
                    description = property.description // add the description part
                    price = String(property.price) // populate the price section
                }
            }
        }
    }
    
    func propS() { // fucntion to to work in property submission
        guard !address.isEmpty, !description.isEmpty, let priceValue = Double(price) else { // verify that all fields are filled and price with valide number
            thrErr = true //flag error fixing
            msgErr = "All fields are required and price must be a valid number." // fixing the error message
            return // when the validates failed it returns
        }
        
        if editM, let property = chooseProp { // check if the property ios choosen or not whether is in modified mode or not
            let modiProp = Property(id: property.id, address: address, description: description, price: priceValue)
            dataManager.propModify(modiProp, for: landlord.id) // make modified property object
            sucMsg = "Property updated successfully!" // add the success message for modification
        } else { // add new property
            let latestPro = Property(id: UUID().uuidString, address: address, description: description, price: priceValue) // with the help of unique ID make new property
            dataManager.propPlus(latestPro, for: landlord.id) // set the new proper to the data manager
            sucMsg = "Property added successfully!" // add success message after added ok
        }
        
        showFor = false // hiding the form after submit
        messSuccess = true // add succcess flag to make it visible success message 
    }
}
