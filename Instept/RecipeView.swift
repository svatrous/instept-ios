import SwiftUI

struct RecipeView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(recipe.title)
                    .font(.largeTitle)
                    .bold()
                
                Text(recipe.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Divider()
                
                Text("Ingredients")
                    .font(.title2)
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(recipe.ingredients, id: \.name) { ingredient in
                        HStack {
                            Text("•")
                            Text(ingredient.name)
                                .bold()
                            Spacer()
                            Text("\(ingredient.amount) \(ingredient.unit)")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Divider()
                
                Text("Steps")
                    .font(.title2)
                    .bold()
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .bold()
                                .frame(width: 24)
                            Text(step)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
