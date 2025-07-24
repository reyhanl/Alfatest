//
//  AppDelegate.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import Foundation
import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    //YOU CAN ADD OTHER UIApplicationDelegate here
    
}
