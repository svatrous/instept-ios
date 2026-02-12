import SwiftUI

struct RecipeOverviewView: View {
    let recipe: Recipe
    @Environment(\.dismiss) var dismiss
    
    // Change this to your backend URL
    private let backendUrl = "https://web-production-11711.up.railway.app"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image Section
                ZStack(alignment: .topLeading) {
                    if let heroUrl = recipe.hero_image_url, let url = URL(string: "\(backendUrl)\(heroUrl)") {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle().fill(Color.gray.opacity(0.3))
                        }
                        .frame(height: 350)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.black.opacity(0.6), .clear, .black.opacity(0.8)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(height: 350)
                    }
                    
                    // Navbar Buttons (Visual only for now, since we are in standard NavView)
                    // We can rely on standard back button or add custom overlay
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Header Info
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(recipe.category.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                Text("\(String(format: "%.1f", recipe.rating)) (\(recipe.reviews_count))")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                            }
                        }
                        
                        Text(recipe.title)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(recipe.description)
                            .font(.body)
                            .foregroundColor(.gray)
                            .lineLimit(3)
                        
                        Button(action: {
                            // Expand text action
                        }) {
                            Text("Read more")
                                .font(.footnote)
                                .foregroundColor(.orange)
                                .fontWeight(.bold)
                        }
                    }
                    
                    // Stats Row
                    HStack(spacing: 12) {
                        StatBox(icon: "clock", label: "TIME", value: recipe.time)
                        StatBox(icon: "chart.bar", label: "LEVEL", value: recipe.difficulty)
                        StatBox(icon: "flame", label: "CAL", value: recipe.calories)
                    }
                    .padding(.vertical, 10)
                    
                    // Ingredients Header
                    HStack {
                        Text("Ingredients")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(recipe.ingredients.count) items")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                    .padding(.top, 10)
                    
                    // Ingredients List
                    VStack(spacing: 12) {
                        ForEach(recipe.ingredients) { ingredient in
                            IngredientRow(ingredient: ingredient)
                        }
                    }
                    
                    // Author Section
                    HStack {
                        Circle() // Avatar placeholder
                            .fill(Color.gray)
                            .frame(width: 40, height: 40)
                            .overlay(Text(recipe.author_name.prefix(1)).foregroundColor(.white))
                        
                        VStack(alignment: .leading) {
                            Text("RECIPE BY")
                                .font(.caption)
                                .foregroundColor(.orange)
                                .fontWeight(.bold)
                            Text(recipe.author_name)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(15)
                    .padding(.vertical, 10)
                    
                    // Start Cooking Button (Navigation Link)
                    NavigationLink(destination: RecipeView(recipe: recipe)) {
                        Text("Start Cooking")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(30)
                    }
                    .padding(.bottom, 20)
                }
                .padding(20)
                .background(Color(red: 0.1, green: 0.1, blue: 0.1)) // Dark background
                .offset(y: -40) // Overlap with hero image slightly
            }
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1).edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatBox: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .font(.system(size: 20))
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
                .fontWeight(.bold)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct IngredientRow: View {
    let ingredient: Ingredient
    @State private var isChecked = false
    
    var body: some View {
        HStack {
            // Icon placeholder based on name (simple mapping or generic)
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 40, height: 40)
                Text(ingredient.name.prefix(1))
                    .foregroundColor(.orange)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading) {
                Text(ingredient.name.capitalized)
                    .font(.body)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                Text("\(ingredient.amount) \(ingredient.unit)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                isChecked.toggle()
            }) {
                Circle()
                    .fill(isChecked ? Color.orange : Color.white)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}
