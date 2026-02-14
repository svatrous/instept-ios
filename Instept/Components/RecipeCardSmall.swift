import SwiftUI

struct RecipeCardSmall: View {
    let recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: recipe.hero_image_url ?? recipe.steps.first?.image_url ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 140, height: 180)
            .clipped()
            
            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.8), .clear]), startPoint: .bottom, endPoint: .center)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(recipe.time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(12)
        }
        .cornerRadius(16)
        .shadow(radius: 4)
        .frame(width: 140, height: 180)
    }
}
