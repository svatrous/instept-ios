import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://web-production-11711.up.railway.app"
    
    func analyzeVideo(url: String) async throws -> Recipe {
        guard let endpoint = URL(string: "\(baseURL)/analyze") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.timeoutInterval = 600 // 5 minutes timeout for image generation
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let language = Locale.current.language.languageCode?.identifier ?? "en"
        let body = AnalyzeRequest(url: url, language: language)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let recipe = try JSONDecoder().decode(Recipe.self, from: data)
        return recipe
    }
}

