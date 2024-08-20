
//
//
//  Activity.swift
//  VoltGo
//
//  Created by Grady Blair on 7/10/24.
//

import SwiftUI

// Sample Activity model
struct Activity: Identifiable {
    let id = UUID()
    let title: String
    let timestamp: Date
    let user: String
}

// Sample data for Activity
let sampleActivities: [Activity] = [
    Activity(title: "Alert 32 Updated", timestamp: Date(), user: "John Doe"),
    Activity(title: "Alert 43 Closed", timestamp: Date().addingTimeInterval(-3600), user: "Alice Smith"),
    Activity(title: "Alert 67 Updated", timestamp: Date().addingTimeInterval(-7200), user: "Bob Johnson"),
    Activity(title: "Endpoint Created", timestamp: Date().addingTimeInterval(-10800), user: "Emma Brown"),
    Activity(title: "Endpoint Shutdown", timestamp: Date().addingTimeInterval(-14400), user: "James Wilson"),
    Activity(title: "Profile updated", timestamp: Date().addingTimeInterval(-18000), user: "Sophia Lee"),
]

struct ActivityView: View {
    let activities: [Activity]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("Activity")
                    .font(.custom("Gordita-Bold", size: 26))
                    
                
                List(activities) { activity in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(activity.title)
                            .font(.custom("Gordita-Bold", size: 18))
                        Text("User: \(activity.user)")
                            .font(.custom("Gordita-Regular", size: 16))
                            .foregroundColor(.secondary)
                        Text("Timestamp: \(formattedDateString(activity.timestamp))")
                            .font(.custom("Gordita-Light", size: 15))
                            .foregroundColor(Color("HTeal"))
                            
                    }
                    
                }
                
               
            }
            .navigationBarHidden(true)
            
        }
    }
    
    private func formattedDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(activities: sampleActivities)
    }
}
