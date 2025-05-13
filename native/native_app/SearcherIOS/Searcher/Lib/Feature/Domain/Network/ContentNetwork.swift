import SwiftUI

protocol ContentNetworkProtocol {
    func fetchContent(query: String?) async throws -> [ContentModel]
    
    func fetchDetailsContent(id: String) async throws -> ContentModel
}


class ContentNetwork: ContentNetworkProtocol {
    let apiKey = "kkj4jS7Yr8HpsYWKhNPlrOBAyQB6Pcha"
    func fetchContent(query: String? = nil) async throws -> [ContentModel] {
        var urlString = "https://api.giphy.com/v1/gifs/search?api_key=\(apiKey)&limit=20"
        if let query = query, !query.isEmpty {
            urlString += "&q=\(query)"
        }
        let (data, _) = try await URLSession.shared.data(from:  URL(string:urlString)!)
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON Response: \(jsonString)")
        }
        let contentData = try JSONDecoder().decode(ContentDataModel.self, from: data)
        
        return contentData.data
    }
    
    func fetchDetailsContent(id: String) async throws -> ContentModel {
        let url = URL(string: "https://api.giphy.com/v1/gifs/\(id)?api_key=\(apiKey)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON Response: \(jsonString)")
        }
        let contentData = try JSONDecoder().decode(ContentDetailsModel.self, from: data)
        
        return contentData.data
        
    }
}
