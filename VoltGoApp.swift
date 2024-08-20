//
//  VoltGoApp.swift
//  VoltGo
//
//  Created by Grady Blair on 6/25/24.
//


import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
}

@main
struct VoltGoApp: App {
    @StateObject private var appState = AppState() // Use @StateObject to instantiate AppState
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(appState) // Inject appState into the environment
        }
    }
}
