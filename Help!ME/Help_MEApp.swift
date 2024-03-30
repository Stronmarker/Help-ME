//
//  Help_MEApp.swift
//  Help!ME
//
//  Created by Alexandre Andres on 29/03/2024.
//

import SwiftUI
import Firebase

@main
struct Help_MEApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Login()
        }
    }
}
