//
//  NotificationManager.swift
//  Stat Tracker V2
//
//  Created by TJ jaglinski on 12/16/24.
//
import UserNotifications

// MARK: - Notification Manager
struct NotificationManager {

    static func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else if granted {
                print("Notification permissions granted.")
            } else {
                print("Notification permissions denied.")
            }
        }
    }

    static func scheduleDailyReminder() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Don't forget to log your tasks for today!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 16 // 4:30 PM
        dateComponents.minute = 30

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "DailyTaskReminder", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled successfully.")
            }
        }
    }
}
