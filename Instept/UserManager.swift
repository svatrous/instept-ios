import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class UserManager: ObservableObject {
    static let shared = UserManager()
    private let db = Firestore.firestore()
    
    @Published var savedRecipeIds: Set<String> = []
    
    private init() {}
    
    func fetchSavedRecipes() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data(), let savedIds = data["saved_recipes"] as? [String] {
                DispatchQueue.main.async {
                    self?.savedRecipeIds = Set(savedIds)
                }
            }
        }
    }
    
    func toggleSaveRecipe(recipeId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let isSaved = savedRecipeIds.contains(recipeId)
        let userRef = db.collection("users").document(userId)
        
        if isSaved {
            // Remove
            userRef.updateData([
                "saved_recipes": FieldValue.arrayRemove([recipeId])
            ]) { [weak self] error in
                if let error = error {
                    print("Error removing recipe: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self?.savedRecipeIds.remove(recipeId)
                    }
                }
            }
        } else {
            // Add
            // Create user document if it doesn't exist
            userRef.setData([
                "saved_recipes": FieldValue.arrayUnion([recipeId])
            ], merge: true) { [weak self] error in
                if let error = error {
                    print("Error saving recipe: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self?.savedRecipeIds.insert(recipeId)
                    }
                }
            }
        }
    }
    
    func isSaved(recipeId: String) -> Bool {
        return savedRecipeIds.contains(recipeId)
    }
}
