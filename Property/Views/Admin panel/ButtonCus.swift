import SwiftUI

struct ButtonCus: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: backgroundColor.opacity(0.3), radius: 5, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1)
        .animation(.easeInOut(duration: 0.2), value: backgroundColor)
    }
}
