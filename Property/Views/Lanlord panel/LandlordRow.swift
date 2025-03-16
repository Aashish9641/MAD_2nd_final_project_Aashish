import SwiftUI // Importing the swift UI

struct LandlordRow: View { // verify the swift view to show the landlord part in a list
    let landlord: Landlord // in order to show landlord make object
    let hasChoose: Bool // if the landlord is choosen identify the boolean
    let selecOn: () -> Void // closure to manage choosen aspect
    let modifyO: () -> Void // handle the modified action
    
    //  adding various Custom Color Scheme
    private let mainColor = Color(red: 0.11, green: 0.38, blue: 0.53) // combination of  color Deep Blue
    private let secColor = Color(red: 0.91, green: 0.94, blue: 0.96) // adding color as Light Gray
    private let actColors = Color(red: 0.20, green: 0.59, blue: 0.86) // setting Sky Blue color
    private let colorDis = Color(red: 0.85, green: 0.22, blue: 0.27) // Coral Red color added
    private let okColor = Color(red: 0.22, green: 0.64, blue: 0.53) // Teal Green for better visibility
    
    var body: some View {
        HStack(spacing: 16) { // to arrange element add space 16
            // add check box for choosing property
            Button(action: selecOn) { // make button to handle choosen
                Image(systemName: hasChoose ? "checkmark.circle.fill" : "circle")// as per choice show the circle
                    .font(.title2) // add the font size
                    .foregroundColor(hasChoose ? mainColor : .gray) // changing the color as per the choosing property
            }
            .buttonStyle(PlainButtonStyle()) // using the plain button style
            
            // Here are the details of landlord
            VStack(alignment: .leading, spacing: 6) { // set vertical stack
                Text(landlord.name) // show the name of landlord
                    .font(.headline) // add the font size
                    .foregroundColor(.primary) // using the text color as primary
                
                HStack(spacing: 8) { // add horizontal stack for email address
                    Image(systemName: "envelope.fill") // use email icon for email address
                        .foregroundColor(.gray) // setting color as gray
                    Text(landlord.email) // show landlord email
                        .font(.subheadline) // set font size
                        .foregroundColor(.secondary) // using secondary color for text field
                }
                
                HStack(spacing: 7) { // add horizontal stack for phone details
                    Image(systemName: "mobile.fill") // add the icon of phone
                        .foregroundColor(.gray) // fix icon color
                    Text(landlord.phone) // show the landlord phone number
                        .font(.subheadline) // add the size of font
                        .foregroundColor(.secondary)// use secondary color as text
                }
            }
            
            Spacer() // usiong spacer to push components left and right side
            
            // for Update Button
            Button(action: modifyO) { // handling the button action
                Text("Update") // set button label as Update
                    .font(.subheadline.bold()) // add font size
                    .foregroundColor(.white) // add text color as white
                    .padding(.horizontal, 12) // add padding in horizontal side+
                    .padding(.vertical, 8) // padding in vertiocal side
                    .background(actColors) // add button background color
                    .cornerRadius(8) // make ropunded corner
                    .shadow(color: actColors.opacity(0.2), radius: 3, y: 2) // for better shadow
            }
            .buttonStyle(PlainButtonStyle()) // adding the plain button design
        }
        .padding() // fix padding around the row
        .background(Color(.systemBackground)) // add background color
        .cornerRadius(12) // add rounder corner with radius 12
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2) // add shadow color to row
        .padding(.horizontal, 8) // add padding in horizontal side
    }
}

// to perform landlord side and row
struct LandlordRow_Previews: PreviewProvider {
    static var previews: some View {
        LandlordRow(
            landlord: Landlord(name: "Binda karki", email: "bindakarki@gmail.com", phone: "34534-345067", properties: []),// sample landlord data used
            hasChoose: false, // indicate that in chosen mode
            selecOn: {}, // in case of nil choosen
            modifyO: {} // niol moified action here
        )
        .padding() // add padding for the preview
        .background(Color(.systemGray6)) // set BG color for preview panel 
    }
}
