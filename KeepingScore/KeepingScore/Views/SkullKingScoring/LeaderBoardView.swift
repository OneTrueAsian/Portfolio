import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var navigateBackToPlayerSetup = false
    @State private var restartGame = false
    @State private var navigateToScoreboard = false // ✅ Fix: Add missing variable
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Leaderboard")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                // Sort players by score
                let sortedPlayers = gameManager.players.sorted { $0.totalScore > $1.totalScore }

                List(sortedPlayers, id: \.id) { player in
                    HStack {
                        Text(player.name)
                        Spacer()
                        Text("\(player.totalScore) pts")
                            .fontWeight(.bold)
                    }
                }
                .padding()

                // HStack for the Done and Restart buttons
                HStack {
                    Button("Done") {
                        gameManager.isGameStarted = false // ✅ Ensure the game does NOT auto-start
                        navigateBackToPlayerSetup = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Restart") {
                        gameManager.resetGame()
                        navigateToScoreboard = true // ✅ NEW - Redirect to Scoreboard
                    }
                    .navigationDestination(isPresented: $navigateToScoreboard) {
                        ScoreInputAndScoreboardView().environmentObject(gameManager) // ✅ Go back to Round 1
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()

            }
            .navigationBarHidden(true) // Hide navigation bar to prevent double navigation bar
            .navigationDestination(isPresented: $navigateBackToPlayerSetup) {
                GameSetupView() // ✅ User is taken ONLY to Player Setup View
            }
        }
    }
}
