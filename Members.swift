

import SwiftUI

struct Member: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let role: String
    // Add more properties as needed
}


import SwiftUI

struct MembersView: View {
    let members = [
        Member(name: "John Doe", email: "john.doe@example.com", role: "Admin"),
        Member(name: "Jane Smith", email: "jane.smith@example.com", role: "Member"),
        // Add more members as needed
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("Members")
                    .font(.custom("Gordita-Bold", size: 26))
                    
                    
            
                List(members) { member in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(member.name)
                            .font(.custom("Gordita-Bold", size: 18))
                        Text(member.email)
                            .font(.custom("Gordita-Regular", size: 16))
                            .foregroundColor(.secondary)
                        Text(member.role)
                            .font(.custom("Gordita-Regular", size: 16))
                            .foregroundColor(Color("HTeal"))
                    }
                }
                
            }
        }
        
        }
    }

struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView()
    }
}
