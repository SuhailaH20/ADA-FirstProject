//
//  StreakManager.swift
//  PawUp
//
//  Created by Suhaylah hawsawi on 10/04/1447 AH.
//
import Foundation
import Combine

enum PetMood {
    case happy
    case crying
    case normal
}

class StreakManager: ObservableObject {
    @Published var streakDays: Int = 0 {
        didSet {
            print("streakDays changed to \(streakDays)")
        }
    }
    
    @Published var petMood: PetMood = .normal

    private let lastCheckKey = "lastCheckDate"
    private let streakKey = "streakCount"

    private var previousStreak: Int = 0
    
    init() {
        loadStreak()
    }

    func loadStreak() {
        let defaults = UserDefaults.standard
        streakDays = defaults.integer(forKey: streakKey)
        previousStreak = streakDays
        petMood = .normal
    }

    func checkInToday() {
        let now = Date()
        let defaults = UserDefaults.standard

        if let lastCheck = defaults.object(forKey: lastCheckKey) as? Date {
            let timeSinceLastCheck = now.timeIntervalSince(lastCheck)
            
            if timeSinceLastCheck <= 60 {
                // Already checked in recently — do nothing
                petMood = .normal
                return
            } else if timeSinceLastCheck <= 120 {
                // Increase streak
                previousStreak = streakDays
                streakDays += 1
                petMood = .happy
            } else {
                // Missed streak — reset
                previousStreak = streakDays
                streakDays = 1
                petMood = .crying
            }
        } else {
            // First check-in
            streakDays = 1
            petMood = .happy
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
                    self.previousStreak = self.streakDays
                    self.streakDays = 0
                    self.petMood = .crying
                }
                defaults.set(0, forKey: streakKey)
            }
        }
    }
}
