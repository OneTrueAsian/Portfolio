import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    @StateObject private var gameManager = GameManager()
    
    var body: some View {
        if gameManager.isGameStarted {
            ScoreInputAndScoreboardView()
                .environmentObject(gameManager)
        } else {
            GameSetupView()
                .environmentObject(gameManager)
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

