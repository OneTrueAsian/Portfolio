import SwiftUI

struct FontDebugView: View {
    var body: some View {
        VStack {
            Text("Font Debugger")
                .font(.title)
                .padding()

            Text("This is an example of Lodeh Regular")
                .font(.custom("Lodeh Regular", size: 32)) // Replace with your custom font name
                .foregroundColor(.black)
                .padding()

            Button("Print All Fonts") {
                listAllFonts() // Trigger font listing on button press
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }

    private func listAllFonts() {
        for family in UIFont.familyNames {
            print("Font family: \(family)")
            for fontName in UIFont.fontNames(forFamilyName: family) {
                print("    Font name: \(fontName)")
            }
        }
    }
}
