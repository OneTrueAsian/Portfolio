import SwiftUI

// View for Simple Scoring
struct SimpleScoringView: View {
    @State private var players: [String] = [] // Player list
    @State private var newPlayer: String = ""
    @State private var navigateToScoring = false
    @State private var numberOfRounds: String = "" // Input for number of rounds
    @State private var showInfoAlert = false // State for showing information alert
    @State private var isIndefiniteRounds: Bool = false // State for indefinite rounds
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Simple Scoring")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Enter the number of rounds:")
                        .font(.headline)
                    
                    Button(action: {
                        showInfoAlert = true
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.leading)
                
                HStack {
                    TextField("Enter number of rounds", text: $numberOfRounds)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                        .frame(maxWidth: 250)
                        .disabled(isIndefiniteRounds)
                    
                    Toggle("Indefinite", isOn: $isIndefiniteRounds)
                        .labelsHidden()
                        .padding(.trailing)
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .alert(isPresented: $showInfoAlert) {
                Alert(title: Text("Number of Rounds"), message: Text("Enter the total number of rounds for the game. The game will continue until all rounds are completed. Toggle on/off if the game should continue indefinitely."), dismissButton: .default(Text("Got it!")))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Add Players:")
                    .font(.headline)
                    .padding(.leading)
                
                HStack {
                    TextField("Enter player name", text: $newPlayer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .frame(maxWidth: 250)
                    
                    Button(action: addPlayer) {
                        Text("Add")
                            .padding()
                            .background(Color.green.opacity(0.7))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            List {
                ForEach(players, id: \..self) { player in
                    HStack {
                        Text(player)
                        Spacer()
                        Button(action: { removePlayer(player) }) {
                            Text("Remove")
                                .padding(6)
                                .background(Color.red.opacity(0.7))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .frame(height: 200)
            .padding(.horizontal)
            
            // Start button to navigate to scoring page
            // New approach for iOS 16+ Navigation
            .navigationDestination(isPresented: $navigateToScoring) {
                ScoringView(players: players, totalRounds: isIndefiniteRounds ? -1 : (Int(numberOfRounds) ?? 1))
            }

            Button(action: {
                navigateToScoring = true
            }) {
                Text("Start")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Simple Scoring")
    }
    
    // Adds a new player to the list
    private func addPlayer() {
        guard !newPlayer.isEmpty else { return }
        players.append(newPlayer)
        newPlayer = ""
    }
    
    // Removes a player from the list
    private func removePlayer(_ player: String) {
        players.removeAll { $0 == player }
    }
}

#Preview {
    SimpleScoringView()
}
