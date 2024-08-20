//
//  Settings.swift
//  VoltGo
//
//  Created by Grady Blair on 7/10/24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Preferences")) {
                    Toggle("Dark Mode", isOn: .constant(false)) // Replace with actual state management
                }
                
                Section(header: Text("Account Management")) {
                    Button(action: {
                        // Action to manage account
                    }) {
                        Text("Manage Account")
                    }
                }
                
                Section(header: Text("App Settings")) {
                    Toggle("Notifications", isOn: .constant(true)) // Replace with actual state management
                    Toggle("Location Services", isOn: .constant(false)) // Replace with actual state management
                }
                
                Section(header: Text("Help & Support")) {
                    Button(action: {
                        // Action to show help or support
                    }) {
                        Text("Help Center")
                    }
                    Button(action: {
                        // Action to contact support
                    }) {
                        Text("Contact Support")
                    }
                }
                
                Section(header: Text("About")) {
                    VStack(alignment: .leading) {
                        Text("Version 1.0.0")
                            .foregroundColor(.gray)
                        Text("Terms of Service")
                            .foregroundColor(.blue)
                        Text("Privacy Policy")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
