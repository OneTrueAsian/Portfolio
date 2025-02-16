import SwiftUI

// MARK: - GameSetupView.swift
// Refactored to integrate with KeepScore without changing the UI
struct GameSetupView: View {
    @EnvironmentObject var gameManager: GameManager // Ensuring state management integration
    @State private var playerNames: [String] = ["", ""]
    @State private var showError: Bool = false // State for error handling
    @State private var errorMessage: String = "" // Error message to display
    
    var body: some View {
            VStack(spacing: 16) {
                Text("Ahoy! Enter Ye Crew")
                    .font(.custom("Lodeh Regular", size: 32))
                
                // VStack containing player names with rounded edges
                VStack(spacing: 8) {
                    ForEach(0..<playerNames.count, id: \.self) { index in
                        TextField("Player \(index + 1)", text: $playerNames[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.5)) // Existing grey background
                .cornerRadius(12) // Rounded edges for the VStack
                
                HStack {
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
                            .background(playerNames.count > 2 ? Color.red : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(playerNames.count <= 2)
                }
                
                Button(action: validateAndStartGame) {
                    Text("Start Game")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // 🔹 Navigation Link - Moves to `ScoreInputAndScoreboardView` when `isGameStarted` is true
                .navigationDestination(isPresented: $gameManager.isGameStarted) {
                    ScoreInputAndScoreboardView() // Transition to scoreboard
                }
            }
            .padding()
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    
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
        // Check for empty player names
        if playerNames.contains(where: { $0.trimmingCharacters(in: .whitespaces).isEmpty }) {
            errorMessage = "Player names cannot be empty. Please fill in all player names."
            showError = true
            return
        }
        
        // Proceed to start the game if validation passes
        gameManager.players = playerNames
            .filter { !$0.isEmpty }
            .map { Player(name: $0) }
        
        gameManager.isGameStarted = true // This will trigger navigation
        print("Game started with players: \(gameManager.players.map { $0.name })")
    }
}
