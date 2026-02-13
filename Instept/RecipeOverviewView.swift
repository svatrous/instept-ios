import SwiftUI

struct RecipeOverviewView: View {
    let recipe: Recipe
    @Environment(\.dismiss) var dismiss
    @State private var showFullDescription = false
    
    // Change this to your backend URL
    private let backendUrl = "https://web-production-11711.up.railway.app"

    // Helper to handle both local and remote (Firebase) URLs
    private func getImageUrl(_ path: String?) -> URL? {
        guard let path = path, !path.isEmpty else { return nil }
        if path.hasPrefix("http") {
            return URL(string: path)
        }
        return URL(string: "\(backendUrl)\(path)")
    }
    
    @StateObject private var userManager = UserManager.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image Section
                ZStack(alignment: .topLeading) {
                    if let url = getImageUrl(recipe.hero_image_url) {
                        CachedAsyncImage(url: url) { image in
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
                    
                    // Header Buttons (Back + Socials)
                    HStack {
                        // Custom Back Button
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        // Right Side Buttons: Instagram, Like, Share
                        HStack(spacing: 12) {
                            Button(action: { /* Open Instagram */ }) {
                                Image(systemName: "camera") // Using camera as proxy for Instagram icon
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            
                            Button(action: {
                                if let id = recipe.id {
                                    userManager.toggleSaveRecipe(recipeId: id)
                                }
                            }) {
                                Image(systemName: (recipe.id != nil && userManager.isSaved(recipeId: recipe.id!)) ? "heart.fill" : "heart")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor((recipe.id != nil && userManager.isSaved(recipeId: recipe.id!)) ? .red : .white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            
                            Button(action: { /* Share action */ }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50) // Adjust for status bar
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
                            showFullDescription = true
                        }) {
                            Text("Read more")
                                .font(.footnote)
                                .foregroundColor(.orange)
                                .fontWeight(.bold)
                        }
                        .sheet(isPresented: $showFullDescription) {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Text("Description")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Button("Close") { showFullDescription = false }
                                }
                                .padding()
                                
                                ScrollView {
                                    Text(recipe.description)
                                        .font(.body)
                                        .padding(.horizontal)
                                }
                            }
                            .presentationDetents([.medium, .large])
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
                        // Avatar placeholder
                        if let url = URL(string: recipe.author_avatar), !recipe.author_avatar.isEmpty {
                             CachedAsyncImage(url: url) { image in
                                 image.resizable().aspectRatio(contentMode: .fill)
                             } placeholder: {
                                 Color.gray
                             }
                             .frame(width: 40, height: 40)
                             .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 40, height: 40)
                                .overlay(Text(recipe.author_name.prefix(1)).foregroundColor(.white))
                        }
                        
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
                    
                    // Start Cooking Button
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
        .edgesIgnoringSafeArea(.top)
        .background(Color(red: 0.1, green: 0.1, blue: 0.1).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
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
