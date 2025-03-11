import SwiftUI

struct CreateLandlordView: View {
    @Binding var showCreateLandlordView: Bool
    @ObservedObject var dataManager: DataManager
    @Binding var landlordToEdit: Landlord?
    
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    
    // Custom color scheme
    private let primaryColor = Color(red: 0.11, green: 0.37, blue: 0.53) // Deep Blue
    private let secondaryColor = Color(red: 0.92, green: 0.94, blue: 0.96) // Light Gray
    private let accentColor = Color(red: 0.20, green: 0.60, blue: 0.86) // Sky Blue
    
    var isEditing: Bool {
        landlordToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Form Fields
                VStack(spacing: 20) {
                    CustomTextField(icon: "person.fill", placeholder: "Landlord Name", text: $name)
                    CustomTextField(icon: "envelope.fill", placeholder: "Email Address", text: $email)
                    CustomTextField(icon: "phone.fill", placeholder: "Phone Number", text: $phone)
                }
                .padding(.horizontal)
                .padding(.top, 24)
                
                // Action Button
                Button(action: saveAction) {
                    Text(isEditing ? "Update Landlord" : "Add Landlord")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [primaryColor, accentColor]),
                                    startPoint: .leading,
                                    endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: primaryColor.opacity(0.3), radius: 8, y: 4)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(secondaryColor.edgesIgnoringSafeArea(.all))
            .navigationTitle(isEditing ? "Edit Landlord" : "New Landlord")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveAction() }
                        .foregroundColor(primaryColor)
                        .disabled(name.isEmpty || email.isEmpty || phone.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { showCreateLandlordView = false }
                        .foregroundColor(primaryColor)
                }
            }
        }
        .onAppear(perform: setupExistingData)
    }
    
    // Custom Text Field Component
    struct CustomTextField: View {
        let icon: String
        let placeholder: String
        @Binding var text: String
        
        var body: some View {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                TextField(placeholder, text: $text)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 3, y: 2)
        }
    }
    
    private func setupExistingData() {
        guard let landlord = landlordToEdit else { return }
        name = landlord.name
        email = landlord.email
        phone = landlord.phone
    }
    
    private func saveAction() {
        guard !name.isEmpty && !email.isEmpty && !phone.isEmpty else { return }
        saveLandlord()
    }
    
    func saveLandlord() {
        // Existing save logic remains unchanged
        if isEditing, let landlord = landlordToEdit {
            let updatedLandlord = Landlord(
                id: landlord.id,
                name: name,
                email: email,
                phone: phone,
                properties: landlord.properties
            )
            dataManager.lordUpdate(updatedLandlord)
        } else {
            let newLandlord = Landlord(
                name: name,
                email: email,
                phone: phone,
                properties: []
            )
            dataManager.lordAdd(newLandlord)
        }
        showCreateLandlordView = false
    }
}
