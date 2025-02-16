import SwiftUI

// Main landing page view
struct LandingPageView: View {
    let items = ["Simple Scoring","Skull King"] // Added Skull King

    var body: some View {
        NavigationStack { // ✅ Ensure NavigationStack is only here
            VStack {
                Text("Keeping Score!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(items, id: \.self) { item in
                        NavigationLink(destination: destinationView(for: item)) {
                            BoxView(title: item) // Tappable boxes
                        }
                    }
                }
                .padding()

                Spacer()
            }
        }
    }

    // Function to return the correct view based on the item selected
    @ViewBuilder
    private func destinationView(for item: String) -> some View {
        switch item {
        case "Simple Scoring":
            SimpleScoringView()
        case "Skull King":
            GameSetupView() // ✅ No need for another NavigationStack inside this view
        default:
            Text("Coming Soon")
        }
    }
}

#Preview {
    LandingPageView()
}
