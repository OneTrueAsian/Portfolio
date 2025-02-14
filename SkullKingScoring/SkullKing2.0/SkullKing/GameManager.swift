import SwiftUI

// MARK: - GameManager.swift
class GameManager: ObservableObject {
    @Published var players: [Player] = []
    @Published var currentRound: Int = 1
    @Published var maxRounds: Int = 10
    @Published var isGameStarted: Bool = false
    
    func calculateScore(bid: Int, tricks: Int, bonus: Int) -> Int {
        print("Calculating score for Bid: \(bid), Tricks: \(tricks)")
        // Case 3: Bid is 0 and Tricks == 0
        if bid == 0 && tricks == 0 {
            return (currentRound * 10) + bonus
        }
        
        // Case 1: Bid matches Tricks
        if bid == tricks {
            return (bid * 20) + bonus
        }
        
        // Case 2: Bid is 0 and Tricks > 0
        if bid == 0 && tricks > 0 {
            return (currentRound * -10) + bonus
        }
        
        // Case 4: Bid does not match Tricks
        return (-abs(bid - tricks) * 10) + bonus
    }
    
    func addRoundScores(scores: [Int], bonuses: [Int]) {
        print("Adding scores: \(scores), with bonuses: \(bonuses)")
        for (index, score) in scores.enumerated() {
            print("Adding \(score + bonuses[index]) to \(players[index].name)'s total score")
            players[index].totalScore += score + bonuses[index]
        }
        currentRound += 1
        print("Moving to round \(currentRound)")
    }
    
    func resetGame() {
        print("Resetting game...")
        DispatchQueue.main.async {
            self.players.removeAll()
            self.currentRound = 1
            self.isGameStarted = false
            print("Game reset complete. Players cleared, round set to 1, game state set to not started.")
        }
    }
}
