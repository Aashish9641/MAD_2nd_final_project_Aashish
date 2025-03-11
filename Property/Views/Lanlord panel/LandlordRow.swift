import SwiftUI

struct LandlordRow: View {
    let landlord: Landlord
    let isSelected: Bool
    let onSelect: () -> Void
    let onUpdate: () -> Void
    
    // Custom Color Scheme
    private let primaryColor = Color(red: 0.11, green: 0.37, blue: 0.53) // Deep Blue
    private let secondaryColor = Color(red: 0.92, green: 0.94, blue: 0.96) // Light Gray
    private let accentColor = Color(red: 0.20, green: 0.60, blue: 0.86) // Sky Blue
    private let destructiveColor = Color(red: 0.86, green: 0.22, blue: 0.27) // Coral Red
    private let successColor = Color(red: 0.22, green: 0.65, blue: 0.53) // Teal Green
    
    var body: some View {
        HStack(spacing: 16) {
            // Checkbox for selection
            Button(action: onSelect) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? primaryColor : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Landlord Details
            VStack(alignment: .leading, spacing: 6) {
                Text(landlord.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.gray)
                    Text(landlord.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.gray)
                    Text(landlord.phone)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Update Button
            Button(action: onUpdate) {
                Text("Update")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(accentColor)
                    .cornerRadius(8)
                    .shadow(color: accentColor.opacity(0.2), radius: 3, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 8)
    }
}

struct LandlordRow_Previews: PreviewProvider {
    static var previews: some View {
        LandlordRow(
            landlord: Landlord(name: "John Doe", email: "john@example.com", phone: "123-456-7890", properties: []),
            isSelected: false,
            onSelect: {},
            onUpdate: {}
        )
        .padding()
        .background(Color(.systemGray6))
    }
}
