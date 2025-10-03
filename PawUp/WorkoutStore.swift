//
//  WorkoutStore.swift
//  PawUp
//
//  Created by dana on 12/04/1447 AH.
//

import Foundation

enum WorkoutStore {
    private static let key = "workout_log_v1" // نخزن Dictionary<String, Bool>

    private static func dateKey(for date: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar.current
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    /// احفظ حالة يوم محدد (افتراضيا اليوم)
    static func set(_ didWorkout: Bool, on date: Date = Date()) {
        var dict = (UserDefaults.standard.dictionary(forKey: key) as? [String: Bool]) ?? [:]
        dict[dateKey(for: date)] = didWorkout
        UserDefaults.standard.set(dict, forKey: key)
    }

    /// رجع الحالة (true/false) لو موجوده، وإلا nil إذا ما فيه سجل
    static func get(on date: Date) -> Bool? {
        let dict = (UserDefaults.standard.dictionary(forKey: key) as? [String: Bool]) ?? [:]
        return dict[dateKey(for: date)]
    }
}
