import Foundation

class RecipeService {
    static let shared = RecipeService()
    
    // Change this to your backend URL
    private let backendUrl = "https://web-production-11711.up.railway.app"
    
    enum RecipeError: Error {
        case invalidURL
        case networkError(Error)
        case decodingError(Error)
        case serverError(String)
    }
    
    func translateRecipe(sourceUrl: String, targetLanguage: String) async throws -> Recipe {
        guard let url = URL(string: "\(backendUrl)/translate") else {
            throw RecipeError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "url": sourceUrl,
            "language": targetLanguage
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RecipeError.serverError("Invalid response")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                 // Try to decode error message
                 if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let detail = errorJson["detail"] as? String {
                     throw RecipeError.serverError(detail)
                 }
                throw RecipeError.serverError("Server returned \(httpResponse.statusCode)")
            }
            
            // Helpful for debugging date decoding issues
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            decoder.dateDecodingStrategy = .iso8601
            
            // Try standard decoding first, if fails might fall back or just rely on model's robust init
            // Model has custom init decoder logic so standard decoder is fine
            
            let decodedRecipe = try JSONDecoder().decode(Recipe.self, from: data)
            return decodedRecipe
        } catch let error as RecipeError {
            throw error 
        } catch {
            throw RecipeError.networkError(error)
        }
    }
}
