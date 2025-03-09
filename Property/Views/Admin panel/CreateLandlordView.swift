import SwiftUI

struct CreateLandlordView: View {
    @Binding var showCreateLandlordView: Bool
    @ObservedObject var dataManager: DataManager
    @Binding var landlordToEdit: Landlord?
    
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    
    var isEditing: Bool {
        landlordToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Landlord Name", text: $name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                TextField("Landlord Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                TextField("Phone Number", text: $phone)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Button(action: {
                    if name.isEmpty || email.isEmpty || phone.isEmpty {
                        // Show alert if any field is empty
                    } else {
                        saveLandlord()
                    }
                }) {
                    Text(isEditing ? "Update Landlord" : "Add Landlord")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 16)
            }
            .padding()
            .navigationTitle(isEditing ? "Edit Landlord" : "Add Landlord")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showCreateLandlordView = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveLandlord()
                    }
                    .disabled(name.isEmpty || email.isEmpty || phone.isEmpty)
                }
            }
        }
        .onAppear {
            if let landlord = landlordToEdit {
                name = landlord.name
                email = landlord.email
                phone = landlord.phone
            }
        }
    }
    
    func saveLandlord() {
        if isEditing, let landlord = landlordToEdit {
            // Update existing landlord
            let updatedLandlord = Landlord(
                id: landlord.id,
                name: name,
                email: email,
                phone: phone,
                properties: landlord.properties
            )
            dataManager.updateLandlord(updatedLandlord)
        } else {
            // Add new landlord
            let newLandlord = Landlord(
                name: name,
                email: email,
                phone: phone,
                properties: []
            )
            dataManager.addLandlord(newLandlord)
        }
        showCreateLandlordView = false
    }
}
