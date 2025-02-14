import SwiftUI

struct PlayerSetupView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var playerNames: [String] = Array(repeating: "", count: 8)
    @State private var playerCount: Int = 2
    
    var body: some View {
        VStack {
            Text("Player Setup")
                .font(.largeTitle)
                .padding()
            
            Stepper(value: $playerCount, in: 2...8) {
                Text("Number of Players: \(playerCount)")
            }
            .padding()
            
            ForEach(0..<playerCount, id: \.self) { index in
                TextField("Enter Player \(index + 1) Name", text: $playerNames[index])
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            
            Button(action: {
                gameManager.players = playerNames
                    .prefix(playerCount)
                    .enumerated()
                    .map { Player(name: $1) }
                gameManager.isGameStarted = true
            }) {
                Text("Start Game")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
    }
}
