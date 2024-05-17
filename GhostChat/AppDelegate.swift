//
//  AppDelegate.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import Foundation

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Perform initial setup tasks here.
        print("app setup tasks")
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppHostWrapper.shared.app?.globalDispatch().emitAction(action: .wakeFromSleep);
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Insert your cleanup code here
        print("Application is about to terminate.")
        AppHostWrapper.shared.app?.shutdown();
        print("i did it!")
        // Save data, close resources, etc.
    }
}
