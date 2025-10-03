//
//  StreakManager.swift
//  PawUp
//
//  Created by Suhaylah hawsawi on 10/04/1447 AH.
//
import Foundation
import Combine

class StreakManager: ObservableObject {
    @Published var streakDays: Int = 0 {
        didSet {
            print("streakDays changed to \(streakDays)")
        }
    }

    private let lastCheckKey = "lastCheckDate"
    private let streakKey = "streakCount"
    
    init() {
        loadStreak()
    }
    
    func loadStreak() {
        let defaults = UserDefaults.standard
        streakDays = defaults.integer(forKey: streakKey)
    }
    
    func checkInToday() {
        let now = Date()
        let defaults = UserDefaults.standard
        
        if let lastCheck = defaults.object(forKey: lastCheckKey) as? Date {
            let timeSinceLastCheck = now.timeIntervalSince(lastCheck) // in seconds
            
            if timeSinceLastCheck <= 60 {
                resetIfMissed()
                // Already checked in within the last minute — do nothing
                return
            } else if timeSinceLastCheck <= 120 {
                // Between 1 and 2 minutes, add to streak
                streakDays += 1
                resetIfMissed()
            } else {
                // More than 2 minutes missed, reset streak
                streakDays = 1
                resetIfMissed()
            }
        } else {
            // First check-in ever
            streakDays = 1
        }
        
        defaults.set(now, forKey: lastCheckKey)
        defaults.set(streakDays, forKey: streakKey)
    }

    
    func resetIfMissed() {
        let defaults = UserDefaults.standard
        if let lastCheck = defaults.object(forKey: lastCheckKey) as? Date {
            let timeSinceLastCheck = Date().timeIntervalSince(lastCheck)
            if timeSinceLastCheck > 120 {
                DispatchQueue.main.async {
                    self.streakDays = 0
                }
                defaults.set(0, forKey: streakKey)
            }
        }
    }

    

}
