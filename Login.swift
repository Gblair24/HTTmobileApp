//
//  Login.swift
//  VoltGo
//
//  Created by Grady Blair on 7/10/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @EnvironmentObject var appState: AppState
    @State private var navigateToContentView: Bool = false

    var body: some View {
        NavigationView{
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("loginlogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                        .padding(.bottom, 10)
                    
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(5.0)
                        .foregroundColor(.white)
                        .frame(width: 250)
                        .padding(.bottom, 20)
                    
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(5.0)
                        .foregroundColor(.white)
                        .frame(width: 250)
                        .padding(.bottom, 20)
                    
                    Button(action: {
                        login()
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200)
                            .background(Color("HOrange"))
                            .cornerRadius(5.0)
                    }
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Spacer()
                }
                .padding()
                .fullScreenCover(isPresented: $navigateToContentView) {
                    DashboardView()
                }
            }
            .environment(\.colorScheme, .dark)
            
        }
        .navigationBarBackButtonHidden()
    }
    
    func login() {
        guard let url = URL(string: "http://localhost:5001/users") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid server URL"
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["username": username, "password": password]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            DispatchQueue.main.async {
                self.errorMessage = "Error encoding login data"
            }
            return
        }
        request.httpBody = bodyData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }

            let responseString = String(data: data, encoding: .utf8)
            print("Response data: \(responseString ?? "")")

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                   let dict = json as? [String: Any],
                   let token = dict["token"] as? String {
                    UserDefaults.standard.set(token, forKey: "token")
                    DispatchQueue.main.async {
                        self.appState.isAuthenticated = true
                        self.navigateToContentView = true // Trigger navigation
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Invalid response from server"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid credentials"
                }
            }
        }.resume()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AppState())
    }
}
