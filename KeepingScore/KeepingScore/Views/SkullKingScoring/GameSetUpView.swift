import SwiftUI

struct GameSetupView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var playerNames: [String] = ["", ""]
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: Title
                    Text("Ahoy! Enter Ye Crew")
                        .font(.custom("Lodeh Regular", size: geo.size.width < 500 ? 28 : 36))
                        .padding(.top)

                    // MARK: Player Inputs
                    VStack(spacing: 12) {
                        ForEach(0..<playerNames.count, id: \.self) { index in
                            TextField("Player \(index + 1)", text: $playerNames[index])
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(height: 44)
                                .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)

                    // MARK: Add/Remove Player Buttons
                    HStack(spacing: 16) {
                        Button(action: addPlayer) {
                            Text("Add Player")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(playerNames.count < 8 ? Color.green : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(playerNames.count >= 8)

                        Button(action: removePlayer) {
                            Text("Remove Player")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(playerNames.count > 2 ? Color.gray : Color.gray.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(playerNames.count <= 2)
                    }

                    // MARK: Start Game Button
                    Button(action: validateAndStartGame) {
                        Text("Start Game")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .navigationDestination(isPresented: $gameManager.isGameStarted) {
                        ScoreInputAndScoreboardView()
                            .environmentObject(gameManager)
                    }

                    Spacer(minLength: 40)
                }
                .frame(maxWidth: 600)
                .padding()
                .frame(width: geo.size.width)
            }
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationTitle("Game Setup")
    }

    // MARK: Logic
    private func addPlayer() {
        if playerNames.count < 8 {
            playerNames.append("")
            print("Added player slot. Total players: \(playerNames.count)")
        }
    }

    private func removePlayer() {
        if playerNames.count > 2 {
            playerNames.removeLast()
            print("Removed player slot. Total players: \(playerNames.count)")
        }
    }

    private func validateAndStartGame() {
        if playerNames.contains(where: { $0.trimmingCharacters(in: .whitespaces).isEmpty }) {
            errorMessage = "Player names cannot be empty. Please fill in all player names."
            showError = true
            return
        }

        gameManager.players = playerNames
            .filter { !$0.isEmpty }
            .map { Player(name: $0) }

        gameManager.isGameStarted = true
        print("Game started with players: \(gameManager.players.map { $0.name })")
    }
}
