//
//  RecipeView.swift
//  Instept
//
//  Created by User on 2026-02-12.
//

import SwiftUI

struct RecipeView: View {
    let recipe: Recipe
    var onHome: () -> Void = {}
    @Environment(\.dismiss) var dismiss
    @State private var currentStepIndex: Int? = 0
    
    // Change this to your backend URL
    private let backendUrl = "https://web-production-11711.up.railway.app"

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                // Vertical ScrollView with Paging
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        // Steps
                        ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                            StepFullScreenView(
                                step: step,
                                index: index,
                                totalSteps: recipe.steps.count,
                                backendUrl: backendUrl,
                                screenSize: geometry.size
                            )
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .id(index)
                        }
                        
                        // Finish Screen
                        FinishCookingView(recipe: recipe, onDismiss: {
                            dismiss()
                        }, onHome: onHome)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .id(recipe.steps.count)
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $currentStepIndex)
                .ignoresSafeArea()
                
                // Top Overlay: Progress Bar and Controls
                if let current = currentStepIndex, current < recipe.steps.count {
                    VStack {
                        // Progress Bar
                        HStack(spacing: 4) {
                            ForEach(0...recipe.steps.count, id: \.self) { index in
                                Capsule()
                                    .fill(index <= current ? Color.orange : Color.gray.opacity(0.5))
                                    .frame(height: 4)
                                    .animation(.easeInOut, value: current)
                            }
                        }
                        .padding(.top, 60)
                        .padding(.horizontal, 10)
                    
                        // Header Controls
                        HStack {
                            // Recipe Title Pill
                            Text(recipe.title)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Capsule())
                                .lineLimit(1)
                            
                            Spacer()
                            
                            // Close Button
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .statusBar(hidden: true)
    }
}

struct StepFullScreenView: View {
    let step: Step
    let index: Int
    let totalSteps: Int
    let backendUrl: String
    let screenSize: CGSize
    
    private func getImageUrl(_ path: String?) -> URL? {
        guard let path = path, !path.isEmpty else { return nil }
        if path.hasPrefix("http") {
            return URL(string: path)
        }
        return URL(string: "\(backendUrl)\(path)")
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Image
            if let imageUrl = step.image_url, let url = getImageUrl(imageUrl) {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screenSize.width, height: screenSize.height)
                        .clipped()
                } placeholder: {
                     ZStack {
                        Rectangle().fill(Color.black)
                            .frame(width: screenSize.width, height: screenSize.height)
                        ProgressView().tint(.white)
                    }
                }
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: screenSize.width, height: screenSize.height)
            }
            
            // Gradient Overlay
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.8), .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: screenSize.height * 0.6)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            
            // Text Content Overlay
            VStack(alignment: .leading, spacing: 12) {
                // Step Indicator
                Text("STEP \(index + 1) of \(totalSteps)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.orange)
                    .background(Color.orange)
                    .cornerRadius(8)
                
                // Ingredients Tags
                if let ingredients = step.ingredients, !ingredients.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(ingredients) { ingredient in
                                Text("\(ingredient.amount) \(ingredient.unit) \(ingredient.name)")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                
                // Description
                Text(step.description)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                
                Text(index == totalSteps - 1 ? "Enjoy your meal!" : "Swipe up for next step")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .opacity(0.8)
                
                // Swipe Indicator
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        if index < totalSteps - 1 {
                            Text("SWIPE UP")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.7))
                            Image(systemName: "chevron.up")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    Spacer()
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
            .frame(width: screenSize.width, alignment: .leading)
        }
        .frame(width: screenSize.width, height: screenSize.height)
    }
}

#Preview {
    RecipeView(
        recipe: Recipe(
            id: "preview-1",
            source_url: nil,
            title: "Creamy Mushroom Risotto",
            description: "A classic Italian risotto.",
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
                Step(description: "Heat olive oil in a large pan over medium heat. Add diced onions and sauté until translucent.", image_url: "https://images.unsplash.com/photo-1556909114-44e3e70034e2?w=800", ingredients: [
                    Ingredient(name: "Olive Oil", amount: "2", unit: "tbsp"),
                    Ingredient(name: "Onion", amount: "1", unit: "medium")
                ]),
                Step(description: "Add sliced mushrooms and cook for 5 minutes until golden brown.", image_url: "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800", ingredients: [
                    Ingredient(name: "Mushrooms", amount: "200", unit: "g")
                ]),
                Step(description: "Add arborio rice and toast for 2 minutes, stirring constantly.", image_url: "https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=800", ingredients: [
                    Ingredient(name: "Arborio Rice", amount: "300", unit: "g")
                ])
            ]
        )
    )
}
