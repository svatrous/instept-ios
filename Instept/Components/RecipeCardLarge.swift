import SwiftUI

struct RecipeCardLarge: View {
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
            .frame(height: 220)
            .clipped()
            
            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.9), .clear]), startPoint: .bottom, endPoint: .top)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("TRENDING")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color("primary"))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                    Spacer()
                }
                
                Text(recipe.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 12) {
                    Label(recipe.time, systemImage: "clock")
                    Label(recipe.difficulty, systemImage: "flame")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            .padding(16)
            
            // Rating badge (top left)
            VStack {
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                        .foregroundColor(Color("primary"))
                        .font(.caption2)
                        Text(String(format: "%.1f", recipe.rating))
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("(\(recipe.reviews_count))")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "heart")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .padding(12)
        }
        .cornerRadius(20)
        .shadow(color: Color("primary").opacity(0.1), radius: 10, x: 0, y: 4)
    }
}
