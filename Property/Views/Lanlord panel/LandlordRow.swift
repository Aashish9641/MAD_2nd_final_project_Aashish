import SwiftUI

struct LandlordRow: View {
    let landlord: Landlord
    let isSelected: Bool
    let onSelect: () -> Void
    let onUpdate: () -> Void
    
    var body: some View {
        HStack {
            // Checkbox for selection
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                .foregroundColor(isSelected ? .blue : .gray)
                .onTapGesture(perform: onSelect)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(landlord.name)
                    .font(.headline)
                Text(landlord.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(landlord.phone)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Update button
            Button(action: onUpdate) {
                Text("Update")
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
    }
}
