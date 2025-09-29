//
//  NotificationManager.swift
//  PawUp
//
//  Created by Areeg Altaiyah on 07/04/1447 AH.
//

import UserNotifications
import UIKit // Needed for UIApplication.shared.registerForRemoteNotifications()

class NotificationManager {

    // 1. Function to request user permission
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notifications: \(error.localizedDescription)")
            }
            
            // Call the completion handler to pass the result back to the view
            completion(granted)
            
            // This registration should happen on the main thread
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    // 2. Function to set up the two daily, recurring notifications
    func scheduleDailyNotificationsWithDifferentContent() {
        let center = UNUserNotificationCenter.current()
        
        // Clear existing pending notifications to avoid duplicates when this function runs.
        center.removeAllPendingNotificationRequests()

        // --- 11:00 AM Notification ---
        
        // 1. Content for 11:00 AM
        let content11AM = UNMutableNotificationContent()
        content11AM.title = "Rise and Shine, Buddy!"
        content11AM.body = "Don’t forget today’s activity! Your furry friend is counting on you 💪."
        content11AM.sound = UNNotificationSound.default
        
        // 2. Trigger for 11:00 AM
        var dateComponents11AM = DateComponents()
        dateComponents11AM.hour = 11
        dateComponents11AM.minute = 0
        let trigger11AM = UNCalendarNotificationTrigger(dateMatching: dateComponents11AM, repeats: true)
        
        // 3. Request and Schedule 11:00 AM
        let request11AM = UNNotificationRequest(
            identifier: "daily_11am",
            content: content11AM,
            trigger: trigger11AM
        )
        
        center.add(request11AM) { (error) in
            if let error = error {
                print("Error scheduling 11 AM notification: \(error.localizedDescription)")
            } else {
                print("11 AM notification scheduled successfully.")
            }
        }


        // --- 9:00 PM Notification ---

        // 1. Content for 9:00 PM
        let content9PM = UNMutableNotificationContent()
        content9PM.title = "Good Night! 🌙"
        content9PM.body = "It's 9 PM. Don't forget to wrap up your day and save your game progress."
        content9PM.sound = UNNotificationSound.default
        
        // 2. Trigger for 9:00 PM
        var dateComponents9PM = DateComponents()
        dateComponents9PM.hour = 21 // 21 is 9 PM in 24-hour time
        dateComponents9PM.minute = 0
        let trigger9PM = UNCalendarNotificationTrigger(dateMatching: dateComponents9PM, repeats: true)

        // 3. Request and Schedule 9:00 PM
        let request9PM = UNNotificationRequest(
            identifier: "daily_9pm",
            content: content9PM,
            trigger: trigger9PM
        )

        center.add(request9PM) { (error) in
            if let error = error {
                print("Error scheduling 9 PM notification: \(error.localizedDescription)")
            } else {
                print("9 PM notification scheduled successfully.")
            }
        }
    }
}
