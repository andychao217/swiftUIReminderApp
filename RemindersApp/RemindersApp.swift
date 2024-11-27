//
//  RemindersAppApp.swift
//  RemindersApp
//
//  Created by Andy Chao on 2024/11/15.
//

import SwiftUI
import UserNotifications

@main
struct RemindersApp: App {
	init() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if granted {
				// notification is granted
			} else {
				// display message to the user
			}
		}
	}
	
    var body: some Scene {
        WindowGroup {
            HomeView()
				.environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
        }
    }
}
