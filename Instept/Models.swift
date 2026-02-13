import Foundation

struct Ingredient: Codable, Identifiable {
    var id: UUID = UUID()
    let name: String
    let amount: String
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case name, amount, unit
    }
}

struct Step: Codable, Hashable {
    let description: String
    let image_url: String?
}

struct Recipe: Codable, Identifiable {
    var id: String?
    let source_url: String?
    let title: String
    let description: String
    let category: String
    let rating: Double
    let reviews_count: Int
    let time: String
    let difficulty: String
    let calories: String
    let author_name: String
    let author_avatar: String
    let hero_image_url: String?
    let ingredients: [Ingredient]
    let steps: [Step]
}

struct AnalyzeRequest: Codable {
    let url: String
    let language: String
}
