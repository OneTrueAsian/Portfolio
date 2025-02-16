import SwiftUI

// View for entering points for each player
struct ScoringView: View {
    var players: [String]
    var totalRounds: Int // Total number of rounds entered by user
    @State private var scores: [String: Int] = [:]
    @State private var enteredPoints: [String: String] = [:] // Holds input values
    @State private var currentRound: Int = 1 // Tracks current round
    @State private var showCompletionAlert = false // Tracks if completion alert should be shown
    @State private var lastRoundSubmitted = false // Tracks if last round has been submitted
    @Environment(\.presentationMode) var presentationMode // ⬅️ Handles navigation back

    init(players: [String], totalRounds: Int) {
        self.players = players
        self.totalRounds = totalRounds
        _scores = State(initialValue: Dictionary(uniqueKeysWithValues: players.map { ($0, 0) }))
        _enteredPoints = State(initialValue: Dictionary(uniqueKeysWithValues: players.map { ($0, "") }))
    }

    var body: some View {
        VStack {
            Text(totalRounds == -1 ? "Round \(currentRound)" : "Round \(currentRound) of \(totalRounds)")
                .font(.title2)
                .bold()
                .padding()

            ScrollView {
                VStack {
                    ForEach(players, id: \.self) { player in
                        HStack {
                            Text(player)
                                .frame(width: 150, alignment: .leading) // ✅ Align player names to the left
                            TextField("Enter points", text: Binding(
                                get: { enteredPoints[player, default: ""] },
                                set: { enteredPoints[player] = $0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 180) // Expanded input width by 50 pixels
                            .keyboardType(.numberPad)
                        }
                        .padding(.horizontal)
                    }

                    Button(action: submitRound) {
                        Text((totalRounds != -1 && currentRound == totalRounds) ? "Enter Score" : "Next Round")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background((totalRounds != -1 && lastRoundSubmitted) ? Color.gray : Color.blue)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .disabled(totalRounds != -1 && lastRoundSubmitted) // Disable only after last round is entered
                }
            }
            .padding()

            // ✅ Scoreboard must be outside ScrollView for correct rendering
            VStack {
                Text("Scoreboard")
                    .font(.title2)
                    .bold()
                    .padding(.top)

                List {
                    ForEach(players, id: \.self) { player in
                        HStack {
                            Text(player)
                                .frame(width: 150, alignment: .leading) //  Align scoreboard names with inputs
                            Spacer()
                            Text("\(scores[player, default: 0]) points")
                                .fontWeight(.bold)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Scoring")
        .alert(isPresented: $showCompletionAlert) {
            Alert(
                title: Text("Max Rounds Reached"),
                message: Text("You have reached the maximum number of rounds. Would you like to start over or finish?"),
                primaryButton: .default(Text("Start Over")) {
                    print("Start Over pressed - Resetting to Round 1")
                    currentRound = 1 // Reset to round 1
                    lastRoundSubmitted = false
                    scores = Dictionary(uniqueKeysWithValues: players.map { ($0, 0) }) // Reset scoreboard
                },
                secondaryButton: .cancel(Text("Finish")) {
                    print("Finish pressed - Navigating back to SimpleScoringView")
                    presentationMode.wrappedValue.dismiss() //  Navigate back to SimpleScoringView
                }
            )
        }
    }

    // Function to submit points for the current round
    private func submitRound() {
        print("Submit round pressed - Current Round: \(currentRound), Total Rounds: \(totalRounds)")

        // Ensure all entered values are valid numbers
        for player in players {
            if let points = Int(enteredPoints[player] ?? "0") {
                scores[player, default: 0] += points
            } else {
                print("Invalid number for \(player), setting to 0")
                scores[player, default: 0] += 0
            }
            enteredPoints[player] = "" // Reset input fields after submission
        }

        // Allow last round to be entered before disabling
        if totalRounds != -1 && currentRound == totalRounds {
            print("Final round submitted. Button will now disable.")
            lastRoundSubmitted = true
            showCompletionAlert = true
        } else {
            currentRound += 1
            print("After submission - Current Round: \(currentRound), Total Rounds: \(totalRounds)")
        }
    }
}

#Preview {
    ScoringView(players: ["Player 1", "Player 2"], totalRounds: 3)
}
