import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: recipe.hero_image_url ?? recipe.steps.first?.image_url ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 80)
            .cornerRadius(12)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("By \(recipe.author_name)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    Text(recipe.difficulty)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green) // Or dynamic color
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                    
                    Label(recipe.time, systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}
