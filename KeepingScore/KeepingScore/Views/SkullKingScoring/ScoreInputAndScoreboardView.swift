import SwiftUI

struct ScoreInputAndScoreboardView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var bids: [String] = []
    @State private var tricks: [String] = []
    @State private var bonuses: [String] = []
    @State private var updatedScores: [String] = []
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isEditing: Bool = false
    @State private var navigateToLeaderboard = false

    // Swipe actions
    @State private var playerToRenameIndex: Int? = nil
    @State private var newName: String = ""
    @State private var showRenameAlert: Bool = false

    @State private var showDeleteConfirmation: Bool = false
    @State private var indexToDelete: Int? = nil

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 16) {
                    //  Round Header
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

                    //  Input Fields for Bids, Tricks, Bonus
                    ForEach(0..<gameManager.players.count, id: \.self) { index in
                        VStack(spacing: 8) {
                            Text(gameManager.players[index].name)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)

                            HStack(spacing: 12) {
                                TextField("Bid", text: binding(for: $bids, index: index))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())

                                TextField("Tricks", text: binding(for: $tricks, index: index))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())

                                TextField("Bonus", text: binding(for: $bonuses, index: index))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    }

                    Divider().padding(.vertical, 8)

                    //  Scoreboard with swipe
                    VStack {
                        Text("Scoreboard")
                            .font(.title2)
                            .bold()
                            .padding(.top)

                        List {
                            ForEach(0..<gameManager.players.count, id: \.self) { index in
                                HStack {
                                    Text(gameManager.players[index].name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 16)

                                    Spacer()

                                    if isEditing {
                                        TextField("Score", text: binding(for: $updatedScores, index: index))
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(width: 100)
                                            .keyboardType(.numberPad)
                                    } else {
                                        Text("\(gameManager.players[index].totalScore)")
                                    }
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        indexToDelete = index
                                        showDeleteConfirmation = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }

                                    Button {
                                        showRenamePrompt(for: index)
                                    } label: {
                                        Label("Rename", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                            }
                        }
                        .frame(height: 250)
                    }
                    .padding()

                    //  Edit/Submit Score Buttons
                    HStack(spacing: 16) {
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
                                .background(gameManager.currentRound > gameManager.maxRounds ? Color.gray : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(gameManager.currentRound > gameManager.maxRounds)
                    }

                    .navigationDestination(isPresented: $navigateToLeaderboard) {
                        LeaderboardView().environmentObject(gameManager)
                    }
                }
                .padding()
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
                .alert("Rename Player", isPresented: $showRenameAlert, actions: {
                    TextField("New name", text: $newName)
                    Button("Save") {
                        if let index = playerToRenameIndex {
                            gameManager.players[index].name = newName
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }, message: {
                    Text("Enter a new name for this player.")
                })
                .alert("Delete Player?", isPresented: $showDeleteConfirmation, actions: {
                    Button("Delete", role: .destructive) {
                        if let index = indexToDelete {
                            gameManager.players.remove(at: index)
                            updatedScores.remove(at: index)
                            bids.remove(at: index)
                            tricks.remove(at: index)
                            bonuses.remove(at: index)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }, message: {
                    Text("Are you sure you want to remove this player and their score?")
                })
                .onAppear {
                    if bids.isEmpty {
                        initializeEntries()
                        initializeEditableScores()
                    }
                }
            }
        }
    }

    // MARK: - Submit Scores Logic
    private func submitScores() {
        let totalTricks = tricks.compactMap { Int($0) }.reduce(0, +)

        if totalTricks > gameManager.currentRound {
            showError = true
            errorMessage = "Total tricks (\(totalTricks)) cannot exceed the round number (\(gameManager.currentRound))."
            return
        }

        var scores = [Int]()
        var bonusValues = [Int]()

        for i in 0..<gameManager.players.count {
            guard let bid = Int(bids[i]), let trick = Int(tricks[i]) else {
                showError = true
                errorMessage = "Invalid input for \(gameManager.players[i].name)."
                return
            }
            let bonus = Int(bonuses[i]) ?? 0
            scores.append(gameManager.calculateScore(bid: bid, tricks: trick, bonus: bonus))
            bonusValues.append(bonus)
        }

        gameManager.addRoundScores(scores: scores, bonuses: bonusValues)
        resetEntries()

        if gameManager.currentRound > gameManager.maxRounds {
            navigateToLeaderboard = true
        }
    }

    private func resetGame() {
        gameManager.resetGame()
        resetEntries()
    }

    private func initializeEntries() {
        let count = gameManager.players.count
        bids = Array(repeating: "", count: count)
        tricks = Array(repeating: "", count: count)
        bonuses = Array(repeating: "", count: count)
    }

    private func resetEntries() {
        bids = Array(repeating: "", count: gameManager.players.count)
        tricks = Array(repeating: "", count: gameManager.players.count)
        bonuses = Array(repeating: "", count: gameManager.players.count)
    }

    private func initializeEditableScores() {
        updatedScores = gameManager.players.map { "\($0.totalScore)" }
    }

    private func toggleEditMode() {
        if isEditing {
            for (index, scoreText) in updatedScores.enumerated() {
                gameManager.players[index].totalScore = Int(scoreText) ?? gameManager.players[index].totalScore
            }
        } else {
            initializeEditableScores()
        }
        isEditing.toggle()
    }

    private func showRenamePrompt(for index: Int) {
        playerToRenameIndex = index
        newName = gameManager.players[index].name
        showRenameAlert = true
    }

    private func binding(for array: Binding<[String]>, index: Int) -> Binding<String> {
        return Binding(
            get: { array.wrappedValue.indices.contains(index) ? array.wrappedValue[index] : "" },
            set: { value in
                if array.wrappedValue.indices.contains(index) {
                    array.wrappedValue[index] = value
                }
            }
        )
    }
}
