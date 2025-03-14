import UIKit
import SwiftUI
struct PropertyFormView: View {
    @Binding var showFor: Bool
    @ObservedObject var dataManager: DataManager
    let landlord: Landlord
    @Binding var chooseProp: Property?
    @Binding var messSuccess: Bool
    @Binding var sucMsg: String
    @Binding var thrErr: Bool
    @Binding var msgErr: String
    
    @State private var address = ""
    @State private var description = ""
    @State private var price = ""
    
    var editM: Bool {
        chooseProp != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Address", text: $address)
                TextField("Description", text: $description)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                
                Button(action: propS) {
                    Text(editM ? "Update Property" : "Add Property")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle(editM ? "Edit Property" : "Add Property")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showFor = false
                    }
                }
            }
            .onAppear {
                if let property = chooseProp {
                    address = property.address
                    description = property.description
                    price = String(property.price)
                }
            }
        }
    }
    
    func propS() {
        guard !address.isEmpty, !description.isEmpty, let priceValue = Double(price) else {
            thrErr = true
            msgErr = "All fields are required and price must be a valid number."
            return
        }
        
        if editM, let property = chooseProp {
            let modiProp = Property(id: property.id, address: address, description: description, price: priceValue)
            dataManager.propModify(modiProp, for: landlord.id)
            sucMsg = "Property updated successfully!"
        } else {
            let latestPro = Property(id: UUID().uuidString, address: address, description: description, price: priceValue)
            dataManager.propPlus(latestPro, for: landlord.id)
            sucMsg = "Property added successfully!"
        }
        
        showFor = false
        messSuccess = true
    }
}
