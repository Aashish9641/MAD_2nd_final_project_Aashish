import SwiftUI // Importing the Swift UI Framework

struct ButtonCus: View { // Custom reusable button elements
    let title: String // for title text button
    let backgroundColor: Color // add BG color for button
    let action: () -> Void // add closure to handle the button action
    
    var body: some View { // Defining the body section
        Button(action: action) { // button with required action
            Text(title) // show the title
                .font(.title2) // add font size
                .fontWeight(.semibold) // add font weight
                .frame(maxWidth: .infinity) // making he full width as per screen
                .padding() // add required padding
                .background(backgroundColor) // set the BG color
                .foregroundColor(.white) // making the text color as white
                .cornerRadius(10) // making the corner of button n
                .shadow(color: backgroundColor.opacity(0.2), radius: 6, x: 0, y: 6) // by using sevberal color add shadow
        }
        .buttonStyle(PlainButtonStyle()) // using the plain style
        .scaleEffect(1) // fixing the scale effect
        .animation(.easeInOut(duration: 0.2), value: backgroundColor) // set animation for smooth movement
    }
}
