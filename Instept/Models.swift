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
    let created_at: Date? 
    let likes_count: Int?
    let ingredients: [Ingredient]
    let steps: [Step]
}

// Helper struct to decode Firestore documents which have nested 'translations'
struct RecipeDocument: Codable {
    let source_url: String?
    let likes_count: Int?
    let created_at: Date?
    let hero_image_url: String?
    let translations: [String: RecipeTranslation]?
    
    // Helper to convert to flat Recipe
    func toRecipe(id: String, language: String = "en") -> Recipe? {
        guard let translations = translations,
              let translation = translations[language] ?? translations["en"] ?? translations.values.first else {
            return nil
        }
        
        return Recipe(
            id: id,
            source_url: source_url,
            title: translation.title,
            description: translation.description,
            category: translation.category,
            rating: translation.rating,
            reviews_count: translation.reviews_count,
            time: translation.time,
            difficulty: translation.difficulty,
            calories: translation.calories,
            author_name: translation.author_name,
            author_avatar: translation.author_avatar,
            hero_image_url: hero_image_url ?? translation.hero_image_url, // Prefer root hero, fallback to translation
            created_at: created_at,
            likes_count: likes_count,
            ingredients: translation.ingredients,
            steps: translation.steps
        )
    }
}

// The inner recipe data inside translations map
struct RecipeTranslation: Codable {
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
