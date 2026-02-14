import Foundation

struct Ingredient: Codable, Identifiable {
    var id: UUID = UUID()
    let name: String
    let amount: String
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case name, amount, unit
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        amount = try container.decodeIfPresent(String.self, forKey: .amount) ?? ""
        unit = try container.decodeIfPresent(String.self, forKey: .unit) ?? ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(amount, forKey: .amount)
        try container.encode(unit, forKey: .unit)
    }
    
    init(id: UUID = UUID(), name: String, amount: String, unit: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.unit = unit
    }
}

struct Step: Codable, Hashable {
    let description: String
    let image_url: String?
    
    enum CodingKeys: String, CodingKey {
        case description, image_url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        image_url = try container.decodeIfPresent(String.self, forKey: .image_url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        try container.encodeIfPresent(image_url, forKey: .image_url)
    }
    
    init(description: String, image_url: String? = nil) {
        self.description = description
        self.image_url = image_url
    }
}

struct Recipe: Codable, Identifiable {
    var id: String?
    var source_url: String?
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
    var author_url: String?
    var hero_image_url: String?
    var created_at: Date?
    var likes_count: Int?
    let ingredients: [Ingredient]
    let steps: [Step]
    var language: String?
    
    enum CodingKeys: String, CodingKey {
        case id, source_url, title, description, category, rating, reviews_count, time, difficulty, calories, author_name, author_avatar, author_url, hero_image_url, created_at, likes_count, ingredients, steps, language
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        source_url = try container.decodeIfPresent(String.self, forKey: .source_url)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Untitled Recipe"
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? "General"
        
        // Robust numeric decoding
        if let r = try? container.decode(Double.self, forKey: .rating) {
            rating = r
        } else if let rInt = try? container.decode(Int.self, forKey: .rating) {
            rating = Double(rInt)
        } else {
            rating = 0.0
        }
        
        if let rc = try? container.decode(Int.self, forKey: .reviews_count) {
            reviews_count = rc
        } else {
            reviews_count = 0
        }
        
        // Robust string/int decoding for metadata
        if let t = try? container.decode(String.self, forKey: .time) {
            time = t
        } else if let tInt = try? container.decode(Int.self, forKey: .time) {
            time = "\(tInt) min"
        } else {
            time = "N/A"
        }
        
        difficulty = try container.decodeIfPresent(String.self, forKey: .difficulty) ?? "Medium"
        
        if let c = try? container.decode(String.self, forKey: .calories) {
            calories = c
        } else if let cInt = try? container.decode(Int.self, forKey: .calories) {
            calories = "\(cInt)"
        } else {
            calories = "N/A"
        }
        
        author_name = try container.decodeIfPresent(String.self, forKey: .author_name) ?? "Chef"
        author_avatar = try container.decodeIfPresent(String.self, forKey: .author_avatar) ?? ""
        author_url = try container.decodeIfPresent(String.self, forKey: .author_url)
        hero_image_url = try container.decodeIfPresent(String.self, forKey: .hero_image_url)
        likes_count = try container.decodeIfPresent(Int.self, forKey: .likes_count)
        
        // Date handling
        if let d = try? container.decodeIfPresent(Date.self, forKey: .created_at) {
            created_at = d
        } else if let dStr = try? container.decodeIfPresent(String.self, forKey: .created_at) {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = isoFormatter.date(from: dStr) {
                created_at = date
            } else {
                let isoFormatterSimple = ISO8601DateFormatter()
                created_at = isoFormatterSimple.date(from: dStr)
            }
        } else {
            created_at = nil
        }
        
        ingredients = try container.decodeIfPresent([Ingredient].self, forKey: .ingredients) ?? []
        steps = try container.decodeIfPresent([Step].self, forKey: .steps) ?? []
        language = try container.decodeIfPresent(String.self, forKey: .language)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(source_url, forKey: .source_url)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(category, forKey: .category)
        try container.encode(rating, forKey: .rating)
        try container.encode(reviews_count, forKey: .reviews_count)
        try container.encode(time, forKey: .time)
        try container.encode(difficulty, forKey: .difficulty)
        try container.encode(calories, forKey: .calories)
        try container.encode(author_name, forKey: .author_name)
        try container.encode(author_avatar, forKey: .author_avatar)
        try container.encodeIfPresent(author_url, forKey: .author_url)
        try container.encodeIfPresent(hero_image_url, forKey: .hero_image_url)
        try container.encodeIfPresent(created_at, forKey: .created_at)
        try container.encodeIfPresent(likes_count, forKey: .likes_count)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(steps, forKey: .steps)
        try container.encodeIfPresent(language, forKey: .language)
    }
    
    // Memberwise Init
    init(id: String? = nil, source_url: String? = nil, title: String, description: String, category: String, rating: Double, reviews_count: Int, time: String, difficulty: String, calories: String, author_name: String, author_avatar: String, author_url: String? = nil, hero_image_url: String? = nil, created_at: Date? = nil, likes_count: Int? = nil, ingredients: [Ingredient], steps: [Step], language: String? = "en") {
        self.id = id
        self.source_url = source_url
        self.title = title
        self.description = description
        self.category = category
        self.rating = rating
        self.reviews_count = reviews_count
        self.time = time
        self.difficulty = difficulty
        self.calories = calories
        self.author_name = author_name
        self.author_avatar = author_avatar
        self.author_url = author_url
        self.hero_image_url = hero_image_url
        self.created_at = created_at
        self.likes_count = likes_count
        self.ingredients = ingredients
        self.steps = steps
        self.language = language
    }
}

// Helper struct to decode Firestore documents which have nested 'translations'
struct RecipeDocument: Codable {
    let source_url: String?
    let likes_count: Int?
    let created_at: Date?
    let hero_image_url: String?
    let author_url: String?
    let rating: Double?
    let reviews_count: Int?
    let translations: [String: RecipeTranslation]?
    
    enum CodingKeys: String, CodingKey {
        case source_url, likes_count, created_at, hero_image_url, author_url, rating, reviews_count, translations
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source_url = try container.decodeIfPresent(String.self, forKey: .source_url)
        likes_count = try container.decodeIfPresent(Int.self, forKey: .likes_count)
        hero_image_url = try container.decodeIfPresent(String.self, forKey: .hero_image_url)
        author_url = try container.decodeIfPresent(String.self, forKey: .author_url)
        
        if let r = try? container.decode(Double.self, forKey: .rating) {
            rating = r
        } else if let rInt = try? container.decode(Int.self, forKey: .rating) {
            rating = Double(rInt)
        } else {
            rating = nil
        }
        
        if let rc = try? container.decode(Int.self, forKey: .reviews_count) {
            reviews_count = rc
        } else {
            reviews_count = nil
        }
        
        translations = try container.decodeIfPresent([String: RecipeTranslation].self, forKey: .translations)
        
        // Robust Date decoding
        if let date = try? container.decodeIfPresent(Date.self, forKey: .created_at) {
            created_at = date
        } else if let dateStr = try? container.decodeIfPresent(String.self, forKey: .created_at) {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let d = isoFormatter.date(from: dateStr) {
                created_at = d
            } else {
                let isoFormatterSimple = ISO8601DateFormatter()
                created_at = isoFormatterSimple.date(from: dateStr)
            }
        } else {
            created_at = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(source_url, forKey: .source_url)
        try container.encodeIfPresent(likes_count, forKey: .likes_count)
        try container.encodeIfPresent(created_at, forKey: .created_at)
        try container.encodeIfPresent(hero_image_url, forKey: .hero_image_url)
        try container.encodeIfPresent(author_url, forKey: .author_url)
        try container.encodeIfPresent(rating, forKey: .rating)
        try container.encodeIfPresent(reviews_count, forKey: .reviews_count)
        try container.encodeIfPresent(translations, forKey: .translations)
    }
    
    // Helper to convert to flat Recipe
    func toRecipe(id: String, language: String = "en") -> Recipe? {
        guard let translations = translations else { return nil }
        
        let selectedLanguage: String
        let translation: RecipeTranslation
        
        if let t = translations[language] {
            selectedLanguage = language
            translation = t
        } else if let t = translations["en"] {
            selectedLanguage = "en"
            translation = t
        } else if let first = translations.first {
            selectedLanguage = first.key
            translation = first.value
        } else {
            return nil
        }
        
        return Recipe(
            id: id,
            source_url: source_url,
            title: translation.title,
            description: translation.description,
            category: translation.category,
            // Ignore fake ratings from translation, use root or 0
            rating: rating ?? 0.0,
            reviews_count: reviews_count ?? 0,
            time: translation.time,
            difficulty: translation.difficulty,
            calories: translation.calories,
            author_name: translation.author_name,
            author_avatar: translation.author_avatar,
            author_url: author_url ?? translation.author_url,
            hero_image_url: hero_image_url ?? translation.hero_image_url, // Prefer root hero, fallback to translation
            created_at: created_at,
            likes_count: likes_count,
            ingredients: translation.ingredients,
            steps: translation.steps,
            language: selectedLanguage
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
    let author_url: String?
    let hero_image_url: String?
    let ingredients: [Ingredient]
    let steps: [Step]
    
    enum CodingKeys: String, CodingKey {
        case title, description, category, rating, reviews_count, time, difficulty, calories, author_name, author_avatar, author_url, hero_image_url, ingredients, steps
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Untitled"
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? "General"
        
        if let r = try? container.decode(Double.self, forKey: .rating) {
            rating = r
        } else if let rInt = try? container.decode(Int.self, forKey: .rating) {
            rating = Double(rInt)
        } else {
            rating = 0.0
        }
        
        if let rc = try? container.decode(Int.self, forKey: .reviews_count) {
            reviews_count = rc
        } else {
            reviews_count = 0
        }
        
        if let t = try? container.decode(String.self, forKey: .time) {
            time = t
        } else if let tInt = try? container.decode(Int.self, forKey: .time) {
            time = "\(tInt) min"
        } else {
            time = "N/A"
        }
        
        difficulty = try container.decodeIfPresent(String.self, forKey: .difficulty) ?? "Medium"
        
        if let c = try? container.decode(String.self, forKey: .calories) {
            calories = c
        } else if let cInt = try? container.decode(Int.self, forKey: .calories) {
            calories = "\(cInt)"
        } else {
            calories = "N/A"
        }
        
        author_name = try container.decodeIfPresent(String.self, forKey: .author_name) ?? "Chef"
        author_avatar = try container.decodeIfPresent(String.self, forKey: .author_avatar) ?? ""
        author_url = try container.decodeIfPresent(String.self, forKey: .author_url)
        hero_image_url = try container.decodeIfPresent(String.self, forKey: .hero_image_url)
        ingredients = try container.decodeIfPresent([Ingredient].self, forKey: .ingredients) ?? []
        steps = try container.decodeIfPresent([Step].self, forKey: .steps) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(title, forKey: .title)
         try container.encode(description, forKey: .description)
         try container.encode(category, forKey: .category)
         try container.encode(rating, forKey: .rating)
         try container.encode(reviews_count, forKey: .reviews_count)
         try container.encode(time, forKey: .time)
         try container.encode(difficulty, forKey: .difficulty)
         try container.encode(calories, forKey: .calories)
         try container.encode(author_name, forKey: .author_name)
         try container.encode(author_avatar, forKey: .author_avatar)
         try container.encodeIfPresent(author_url, forKey: .author_url)
         try container.encodeIfPresent(hero_image_url, forKey: .hero_image_url)
         try container.encode(ingredients, forKey: .ingredients)
         try container.encode(steps, forKey: .steps)
    }
}

struct AnalyzeRequest: Codable {
    let url: String
    let language: String
}
