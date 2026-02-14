import SwiftUI

struct FinishCookingView: View {
    let recipe: Recipe
    var onDismiss: () -> Void
    var onHome: () -> Void
    
    @State private var rating: Int = 0
    @State private var animate = false
    @State private var hasRated = false
    @State private var isSubmitting = false
    
    private let backendUrl = "https://web-production-11711.up.railway.app"
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            // Use safe area inset if available, otherwise fallback to standard notch height + padding
            let safeTop = geo.safeAreaInsets.top > 0 ? geo.safeAreaInsets.top : 47
            
            ZStack {
                // Background Image
                CachedAsyncImage(url: URL(string: recipe.hero_image_url ?? recipe.steps.last?.image_url ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: w, height: h)
                        .clipped()
                } placeholder: {
                    Color("background-dark")
                        .frame(width: w, height: h)
                }
                
                // Dark overlay
                Color.black.opacity(0.6)
                
                // Gradient overlay
                LinearGradient(
                    gradient: Gradient(colors: [Color("background-dark"), .clear, Color.black.opacity(0.4)]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                
                // Floating Elements — use geo, not UIScreen
                floatingElements(width: w, height: h)
                    .allowsHitTesting(false)
                    .opacity(0.4)
                
                // Main Content
                VStack(spacing: 0) {
                    // Close button
                    HStack {
                        Spacer()
                        Button(action: onDismiss) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 36, height: 36)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, safeTop + 10)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Center content
                    VStack(spacing: 20) {
                        // Badge
                        Text("Recipe Completed")
                            .font(.caption)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .tracking(2)
                            .foregroundColor(Color("primary"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color("primary").opacity(0.2))
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("primary").opacity(0.3), lineWidth: 1))
                        
                        // Title
                        Text("Bon Appétit!")
                            .font(.system(size: 44, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        // Subtitle
                        Text("You've mastered the \(recipe.title).")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                        
                        // Rating
                        VStack(spacing: 12) {
                            Text("HOW WAS YOUR MEAL?")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .tracking(1.5)
                                .foregroundColor(.white.opacity(0.9))
                            
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { index in
                                    Button(action: {
                                        if !hasRated && !isSubmitting {
                                            withAnimation(.spring()) {
                                                rating = index
                                            }
                                            submitRating(index)
                                        }
                                    }) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(index <= rating ? Color("primary") : Color.white.opacity(0.2))
                                            .shadow(color: index <= rating ? Color("primary").opacity(0.6) : .clear, radius: 8, x: 0, y: 0)
                                            .scaleEffect(index == rating ? 1.2 : 1.0)
                                    }
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                        if hasRated {
                            Text("Thanks for your feedback!")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(Color.green.opacity(0.9))
                                .transition(.opacity.combined(with: .scale))
                        } else if isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    // Buttons
                    VStack(spacing: 12) {
                        Button(action: onHome) {
                            Text("Back to Home")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color("primary"))
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .shadow(color: Color("primary").opacity(0.4), radius: 20, x: 0, y: 4)
                        }
                        

                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
            .frame(width: w, height: h)
            .clipped() // Prevent ANY overflow
        }
    }
    
    @ViewBuilder
    private func floatingElements(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(Color("primary").opacity(0.8))
                .frame(width: 10, height: 10)
                .position(x: width * 0.2, y: height * 0.1)
                .offset(y: animate ? -10 : 0)
            
            Rectangle()
                .fill(Color.yellow)
                .frame(width: 6, height: 14)
                .rotationEffect(.degrees(45))
                .opacity(0.8)
                .position(x: width * 0.8, y: height * 0.2)
                .offset(y: animate ? -8 : 0)
            
            Rectangle()
                .fill(Color.white.opacity(0.6))
                .frame(width: 10, height: 10)
                .rotationEffect(.degrees(12))
                .position(x: width * 0.55, y: height * 0.15)
                .offset(y: animate ? -12 : 0)
            
            Circle()
                .fill(Color.orange.opacity(0.7))
                .frame(width: 6, height: 6)
                .position(x: width * 0.65, y: height * 0.08)
                .offset(y: animate ? -6 : 0)
            
            Rectangle()
                .fill(Color("primary").opacity(0.5))
                .frame(width: 14, height: 6)
                .rotationEffect(.degrees(-12))
                .position(x: width * 0.12, y: height * 0.28)
                .offset(y: animate ? -10 : 0)
            
            Circle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 6, height: 6)
                .position(x: width * 0.88, y: height * 0.22)
                .offset(y: animate ? -8 : 0)
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }

    
    private func submitRating(_ rating: Int) {
        guard let recipeId = recipe.id, !recipeId.isEmpty else { return }
        
        isSubmitting = true
        
        guard let url = URL(string: "\(backendUrl)/rate") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["recipe_id": recipeId, "rating": rating]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                isSubmitting = false
                withAnimation {
                    hasRated = true
                }
            }
        }.resume()
    }
}

#Preview {
    FinishCookingView(
        recipe: Recipe(
            id: "preview-1",
            source_url: nil,
            title: "Creamy Mushroom Risotto",
            description: "A classic Italian risotto with earthy mushrooms and parmesan.",
            category: "Italian",
            rating: 4.8,
            reviews_count: 124,
            time: "45 min",
            difficulty: "Medium",
            calories: "520 kcal",
            author_name: "Chef Mario",
            author_avatar: "",
            hero_image_url: "https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=800",
            created_at: nil,
            likes_count: 42,
            ingredients: [
                Ingredient(name: "Arborio Rice", amount: "300", unit: "g"),
                Ingredient(name: "Mushrooms", amount: "200", unit: "g")
            ],
            steps: [
                Step(description: "Sauté mushrooms in butter until golden.", image_url: nil),
                Step(description: "Add rice and toast for 2 minutes.", image_url: nil),
                Step(description: "Gradually add broth, stirring constantly.", image_url: nil)
            ]
        ),
        onDismiss: {},
        onHome: {}
    )
}
