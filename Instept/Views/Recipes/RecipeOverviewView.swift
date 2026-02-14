import SwiftUI

struct RecipeOverviewView: View {
    let recipe: Recipe
    @Environment(\.dismiss) var dismiss
    @State private var showFullDescription = false
    @State private var translatedRecipe: Recipe?
    @State private var isTranslating = false
    
    private var displayRecipe: Recipe {
        translatedRecipe ?? recipe
    }
    
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
        let recipe = displayRecipe
        ZStack(alignment: .bottom) {
            
            // Main Content Layer
            ZStack(alignment: .top) {
                
                // 1. Fixed Background Image
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
                    .ignoresSafeArea(edges: .top)
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 350)
                        .ignoresSafeArea(edges: .top)
                }
                
                // 2. Scrollable Content
                ScrollView {
                    VStack(spacing: 0) {
                        // Transparent spacer to reveal the fixed image behind
                        Color.clear
                            .frame(height: 280) // Adjust height to ensure content starts below buttons initially
                        
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
                            
                        }
                        .padding(20)
                        .background(Color(red: 0.1, green: 0.1, blue: 0.1)) // Dark background for content
                        .cornerRadius(20) // Rounded top corners
                        .padding(.bottom, 80) // Add padding for fixed button
                    }
                }
                .ignoresSafeArea(edges: .top) // Ensure ScrollView scrolls up to top edge over image
                
                // 3. Header Buttons (Back + Socials) - Fixed at Top
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
                        // Translate Button (PRO)
                        if recipe.language != (Locale.current.language.languageCode?.identifier ?? "en") {
                            Button(action: {
                                Task {
                                    isTranslating = true
                                    do {
                                        let targetLang = Locale.current.language.languageCode?.identifier ?? "en"
                                        if let sourceUrl = recipe.source_url {
                                            let translated = try await RecipeService.shared.translateRecipe(sourceUrl: sourceUrl, targetLanguage: targetLang)
                                            withAnimation {
                                                translatedRecipe = translated
                                            }
                                        }
                                    } catch {
                                        print("Translation failed: \(error)")
                                    }
                                    isTranslating = false
                                }
                            }) {
                                ZStack(alignment: .topTrailing) {
                                    if isTranslating {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .padding(10)
                                            .background(Color.black.opacity(0.5))
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "translate")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color.black.opacity(0.5))
                                            .clipShape(Circle())
                                        
                                        Text("AI")
                                            .font(.system(size: 8, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 2)
                                            .background(Color.orange)
                                            .cornerRadius(4)
                                            .offset(x: 4, y: -4)
                                    }
                                }
                            }
                        }
                        
                        Button(action: {
                            if let urlStr = recipe.source_url, let url = URL(string: urlStr) {
                                UIApplication.shared.open(url)
                            }
                        }) {
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
                .padding(.top, 10)
            }

            // Fixed Bottom Button
            VStack {
                Spacer()
                VStack {
                    NavigationLink(destination: RecipeView(recipe: recipe)) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Cooking")
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(16)
                        .shadow(color: Color.orange.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10) // Safe area handled by background
                .background(
                    Color(red: 0.1, green: 0.1, blue: 0.1)
                        .opacity(0.9)
                        .ignoresSafeArea()
                        .blur(radius: 0)
                )
                .background(.ultraThinMaterial)
            }
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }
}


