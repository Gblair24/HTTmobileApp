
import SwiftUI
import Foundation

struct CommentResponse: Codable, Identifiable {
    let id: Int
    let alert_id: Int
    let created_at: String
    let email: String
    let text: String
    let username: String
}

func fetchComments(for alertID: Int, token: String, completion: @escaping (Result<[CommentResponse], Error>) -> Void) {
    let urlString = "https://api.dev.httech.io/api/alerts/\(alertID)/comments"  //fix with new api from sam
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        let urlError = NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        completion(.failure(urlError))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let statusError = NSError(domain: "Invalid response", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
            completion(.failure(statusError))
            return
        }

        guard let data = data else {
            let dataError = NSError(domain: "No data", code: -1, userInfo: nil)
            completion(.failure(dataError))
            return
        }

        do {
            let commentResponses = try JSONDecoder().decode([CommentResponse].self, from: data)
            completion(.success(commentResponses))
        } catch {
            completion(.failure(error))
        }
    }
    
    task.resume()
}

struct AlertDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let alert: Alert
    
    @State private var comments: [CommentResponse] = []
    @State private var isLoading: Bool = false
    @State private var fetchFailed: Bool = false // New state to track fetch failure
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Alert Details")
                    .font(.custom("Gordita-Bold", size: 24))
                    .padding(.bottom)
                Text("Title: \(alert.title)")
                    .font(.custom("Gordita-Regular", size: 20))
                Text("ID: \(alert.id)")
                    .font(.custom("Gordita-Regular", size: 18))
                Text("Description: \(alert.description)")
                    .font(.custom("Gordita-Regular", size: 18))
                Text("Severity: \(alert.severity)")
                    .font(.custom("Gordita-Regular", size: 18))
                Text("Status: \(alert.status)")
                    .font(.custom("Gordita-Regular", size: 18))
                Text("Created At: \(formattedDate(alert.createdAt))")
                    .font(.custom("Gordita-Regular", size: 18))
                Text("Updated At: \(formattedDate(alert.updatedAt))")
                    .font(.custom("Gordita-Regular", size: 18))
                // Add other fields as needed
                
                Text("Comments")
                    .font(.custom("Gordita-Bold", size: 20))
                    .padding(.top)
                    .padding(.trailing, 230)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if fetchFailed || comments.isEmpty {
                    Text("No comments available")
                        .font(.custom("Gordita-Regular", size: 18))
                        .padding()
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(comments) { comment in
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Username: \(comment.username)")
                                    .font(.custom("Gordita-Regular", size: 18))
                                Text("Email: \(comment.email)")
                                    .font(.custom("Gordita-Regular", size: 18))
                                Text("Created At: \(formattedDateString(comment.created_at))")
                                    .font(.custom("Gordita-Regular", size: 18))
                                    .padding(.bottom)
                                Text("Comment: \(comment.text)")
                                    .font(.custom("Gordita-Regular", size: 18))
                            }
                            .padding()
                            Divider()
                        }
                    }
                    .background(Color("Charcoal"))
                    .cornerRadius(8.0)
                    .padding()
                }
            }
            .padding()
        }
        .onAppear {
            // Fetch comments when the view appears
            isLoading = true
            fetchComments(for: alert.id, token: "226d5597-6efc-46e6-9dc1-11304ce1a9d5") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let commentResponses):
                        self.comments = commentResponses
                        self.fetchFailed = false
                    case .failure(let error):
                        print("Error fetching comments: \(error.localizedDescription)")
                        self.fetchFailed = true
                    }
                    
                    isLoading = false
                }
            }
        }
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss() // Go back to the previous view
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        })
        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
    
    private func formattedDateString(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .medium
            return displayFormatter.string(from: date)
        } else {
            return dateString
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}
