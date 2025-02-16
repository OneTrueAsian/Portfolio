import SwiftUI

struct RoundSelectionView: View {
    var body: some View {
        VStack {
            Text("Select Rounds")
                .font(.title)
                .padding()
            
            Button(action: {
                startGame(rounds: 10)
            }) {
                Text("Start Game with 10 Rounds")
            }
            
            Button(action: {
                startGame(rounds: 5)
            }) {
                Text("Start Game with 5 Rounds")
            }
        }
        .onAppear {
            print("RoundSelectionView has appeared")
        }
        .padding()
    }
    
    /// Function to start the game with the specified number of rounds.
    func startGame(rounds: Int) {
        print("DEBUG: startGame called with \(rounds) rounds")
        
        // Simulating some logic
        let message = "Game starting with \(rounds) rounds."
        print("INFO: \(message)")
    }
}

struct RoundSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RoundSelectionView()
    }
}
