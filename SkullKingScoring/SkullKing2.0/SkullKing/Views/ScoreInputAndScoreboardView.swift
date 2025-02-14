import SwiftUI

struct ScoreInputAndScoreboardView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var bids: [String] = []
    @State private var tricks: [String] = []
    @State private var bonuses: [String] = []
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isEditing: Bool = false // Toggle edit mode
    @State private var updatedScores: [String] = [] // Holds editable scores

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Text("Round \(gameManager.currentRound)")
                        .font(.system(size: geometry.size.width * 0.07, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.blue)
                        .padding(.leading, 16)
                    Spacer()
                    
                    Button(action: resetGame) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: geometry.size.width * 0.06))
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                
                ScrollView {
                    ForEach(0..<gameManager.players.count, id: \.self) { index in
                        VStack(spacing: 8) {
                            Text(gameManager.players[index].name)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                            HStack(spacing: 12) {
                                TextField("Bid", text: $bids[safe: index] ?? .constant(""))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("Tricks", text: $tricks[safe: index] ?? .constant(""))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("Bonus", text: $bonuses[safe: index] ?? .constant(""))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    }
                }
                
                Divider().padding(.vertical, 8)
                
                List {
                    ForEach(0..<gameManager.players.count, id: \.self) { index in
                        HStack {
                            Text(gameManager.players[index].name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                            Spacer()
                            
                            if isEditing {
                                // Editable TextField for Scores
                                TextField(
                                    "Score",
                                    text: $updatedScores[safe: index] ?? .constant("")
                                )
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                            } else {
                                // Display Player's Total Score
                                Text("\(gameManager.players[index].totalScore)")
                            }
                        }
                    }
                }
                
                HStack(spacing: 16) {
                    // Edit Score Button
                    Button(action: toggleEditMode) {
                        Text(isEditing ? "Done Editing" : "Edit Score")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isEditing ? Color.green : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: submitScores) {
                        Text("Submit Scores")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                syncInputsWithPlayers()
                initializeEditableScores() // Pre-fill updatedScores with current total scores
            }
        }
    }
    
    private func syncInputsWithPlayers() {
        let count = gameManager.players.count
        bids = Array(repeating: "", count: count)
        tricks = Array(repeating: "", count: count)
        bonuses = Array(repeating: "", count: count)
        print("Synced inputs with players. Players count: \(count)")
    }
    
    private func initializeEditableScores() {
        updatedScores = gameManager.players.map { "\($0.totalScore)" }
        print("Initialized editable scores: \(updatedScores)")
    }
    
    private func toggleEditMode() {
        if isEditing {
            // Save updated scores back to players
            for (index, scoreText) in updatedScores.enumerated() {
                if let newScore = Int(scoreText) {
                    gameManager.players[index].totalScore = newScore
                } else {
                    print("Invalid score for player \(gameManager.players[index].name), skipping update.")
                }
            }
        } else {
            // Refresh scores to match the latest player scores
            initializeEditableScores()
        }
        isEditing.toggle()
    }
    
    private func submitScores() {
        var scores = [Int]()
        var bonusValues = [Int]()
        
        for i in 0..<gameManager.players.count {
            guard let bid = Int(bids[safe: i] ?? ""), let trick = Int(tricks[safe: i] ?? "") else {
                showError = true
                errorMessage = "Invalid input for \(gameManager.players[i].name)."
                print("Error: \(errorMessage)")
                return
            }
            let bonus = Int(bonuses[safe: i] ?? "0") ?? 0
            print("Player \(gameManager.players[i].name): Bid = \(bid), Tricks = \(trick), Bonus = \(bonus)")
            scores.append(gameManager.calculateScore(bid: bid, tricks: trick, bonus: bonus))
            bonusValues.append(bonus)
        }
        
        print("Submitting scores: \(scores), bonuses: \(bonusValues)")
        gameManager.addRoundScores(scores: scores, bonuses: bonusValues)
        syncInputsWithPlayers()
    }
    
    private func resetGame() {
        gameManager.resetGame()
        syncInputsWithPlayers()
        print("Game has been reset.")
    }
}
