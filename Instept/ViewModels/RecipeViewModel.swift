import Foundation
import Combine

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipe: Recipe?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager = NetworkManager.shared
    
    func analyzeMetadata(url: String) {
        guard !url.isEmpty else {
            errorMessage = "Please enter a valid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        recipe = nil
        
        Task {
            do {
                let result = try await networkManager.analyzeVideo(url: url)
                self.recipe = result
                
                // Auto-save recipe
                if let recipeId = result.id {
                    UserManager.shared.saveRecipe(recipeId: recipeId)
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
}
