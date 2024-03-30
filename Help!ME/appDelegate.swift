//
//  appDelegate.swift
//  Help!ME
//
//  Created by Alexandre Andres on 29/03/2024.
//

import Foundation
import UIKit
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure() // Configure Firebase
        
        return true
    }
}
