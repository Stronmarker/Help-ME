//
//  Help_MEApp.swift
//  Help!ME
//
//  Created by Alexandre Andres-Robert on 29/03/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct YourApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            // Inject AuthManager as an EnvironmentObject            
            Login()
                .environmentObject(AuthManager())

        }
    }
}

class AuthManager: ObservableObject {
    @Published var currentUser: User?
    
    init() {
        listenForAuthChanges()
    }
    
    func listenForAuthChanges() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.currentUser = user
            } else {
                self.currentUser = nil
            }
        }
    }
}





