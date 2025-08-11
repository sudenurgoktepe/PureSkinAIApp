//
//  AppDelegate.swift
//  PureSkinAIApp
//
//  Created by sude on 29.03.2025.
//

import UIKit
import UserNotifications


@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        requestNotificationPermission()
        scheduleDailyMorningNotification()
        scheduleDailyEveningNotification()
        return true
    }
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Bildirim izni verildi.")
            } else {
                print("Bildirim izni reddedildi.")
            }
        }
    }

    func scheduleDailyMorningNotification() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Sabah Rutini Zamanı"
        content.body = "Sabah cilt bakımını yapmayı unutma 🌞✨"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 09
        dateComponents.minute = 00

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "morningRoutineReminder", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Bildirim ayarlanamadı: \(error.localizedDescription)")
            } else {
                print("Sabah bildirimi ayarlandı.")
            }
        }
    }
    
    func scheduleDailyEveningNotification() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Akşam Rutini Zamanı"
        content.body = "Akşam cilt bakımını yapmayı unutma 🌙✨"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 21  
        dateComponents.minute = 15

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "eveningRoutineReminder", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Akşam bildirimi ayarlanamadı: \(error.localizedDescription)")
            } else {
                print("Akşam bildirimi ayarlandı.")
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

