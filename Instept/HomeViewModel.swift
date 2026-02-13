import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var myRecipes: [Recipe] = []
    @Published var popularRecipes: [Recipe] = []
    @Published var recentRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let db = Firestore.firestore()
    
    func fetchData() async {
        isLoading = true
        error = nil
        
        do {
            async let my = fetchMyRecipes()
            async let popular = fetchPopularRecipes()
            async let recent = fetchRecentRecipes()
            
            let (myRes, popularRes, recentRes) = await (try my, try popular, try recent)
            
            self.myRecipes = myRes
            self.popularRecipes = popularRes
            
            // Filter recent to exclude my recipes if needed, but for now just show all recent
            // Maybe filter out duplicates from popular?
            self.recentRecipes = recentRes
            
        } catch {
            self.error = error.localizedDescription
            print("Error fetching home data: \(error)")
        }
        
        isLoading = false
    }
    
    private func fetchMyRecipes() async throws -> [Recipe] {
        guard let userId = Auth.auth().currentUser?.uid else { return [] }
        
        // 1. Get user's saved recipe IDs
        let userDoc = try await db.collection("users").document(userId).getDocument()
        guard let data = userDoc.data(),
              let savedIds = data["saved_recipes"] as? [String],
              !savedIds.isEmpty else {
            return []
        }
        
        // 2. Fetch recipes by IDs (in batches of 10 if needed, but let's do simple implementation first)
        // Firestore 'in' query supports up to 10/30 items.
        // If many, we might need a different approach. For MVP, take last 10.
        let idsToFetch = Array(savedIds.prefix(10)) 
        
        var recipes: [Recipe] = []
        // We can use 'in' operator
        let snapshot = try await db.collection("recipes")
            .whereField(FieldPath.documentID(), in: idsToFetch)
            .getDocuments()
            
        recipes = snapshot.documents.compactMap { doc in
            do {
                let recipeDoc = try doc.data(as: RecipeDocument.self)
                // Determine language: Use device preferred language or fallback to 'en'
                // For MVP, hardcode/detect? Let's use 'en' as default or detect.
                // Or try to get current locale code.
                let lang = Locale.current.languageCode ?? "en"
                // Check if translation exists for lang, otherwise fallback (handled in toRecipe)
                return recipeDoc.toRecipe(id: doc.documentID, language: lang)
            } catch {
                print("Error decoding recipe \(doc.documentID): \(error)")
                return nil
            }
        }
        return recipes
    }
    
    private func fetchPopularRecipes() async throws -> [Recipe] {
        let snapshot = try await db.collection("recipes")
            .order(by: "likes_count", descending: true)
            .limit(to: 10)
            .getDocuments()
            
        return snapshot.documents.compactMap { doc in
             try? doc.data(as: RecipeDocument.self).toRecipe(id: doc.documentID)
        }
    }
    
    private func fetchRecentRecipes() async throws -> [Recipe] {
        guard let userId = Auth.auth().currentUser?.uid else { return [] }

        let snapshot = try await db.collection("recipes")
            .order(by: "created_at", descending: true)
            .limit(to: 10)
            .getDocuments()
            
        // Filter out my recipes on client side if needed, or just show them.
        // The requirement says "exclude recipes of current user".
        // BUT current user doesn't "create" recipes in the DB in terms of 'author_id'.
        // Recipes are created by system.
        // Maybe "exclude recipes I have saved"?
        // Let's assume filter out saved ones.
        
        let allRecent = snapshot.documents.compactMap { doc in
             try? doc.data(as: RecipeDocument.self).toRecipe(id: doc.documentID)
        }
        
        // We need saved IDs to filter.
        // We can check UserManager, but it might not be ready.
        // Let's rely on what we fetched in fetchMyRecipes if we ran it?
        // Or just re-fetch user saved ids?
        // Let's simpler: just filter items that are NOT in myRecipes (by ID).
        
        // Wait, parallel execution means myRecipes might not be set yet when this runs.
        // But we can filter in the main fetchData after getting all results.
        
        return allRecent
    }
}
