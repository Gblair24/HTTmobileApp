//
//  News.swift
//  VoltGo
//
//  Created by Grady Blair on 7/2/24.
//

import SwiftUI
import Combine

struct Article: Identifiable, Codable {
    var id = UUID()
    let title: String
    let link: String
    
    private enum CodingKeys: String, CodingKey {
        case title, link
    }
}

struct ScrapedData: Codable {
    let krebs: [Article]
    let threatpost: [Article]
}

class ArticleViewModel: ObservableObject {
    @Published var articles = [Article]()
    
    func fetchArticles() {
        guard let url = URL(string: "http://127.0.0.1:5000/scrape") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ScrapedData.self, from: data)
                    DispatchQueue.main.async {
                        self.articles = decodedData.krebs + decodedData.threatpost
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}

struct NewsView: View {
    @ObservedObject var viewModel = ArticleViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Security Articles")
                    .font(.custom("Gordita-Bold", size: 26))
                List(viewModel.articles) { article in
                    VStack(alignment: .leading) {
                        Text(article.title)
                            .font(.custom("Gordita-Regular", size: 18))
                        Link(destination: URL(string: article.link)!) {
                            Text("Read more")
                                .foregroundColor(Color("HTeal"))
                                .font(.custom("Gordita-Light", size: 18))
                        }
                    }
                    .padding()
                }
                .padding(.vertical, -15)
                .onAppear {
                    viewModel.fetchArticles()
                }
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewsView()
        }
    }
}
