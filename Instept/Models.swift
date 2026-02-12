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

struct Recipe: Codable {
    let title: String
    let description: String
    let ingredients: [Ingredient]
    let steps: [String]
}

struct AnalyzeRequest: Codable {
    let url: String
}
