//
//  RecipeView.swift
//  Instept
//
//  Created by User on 2026-02-12.
//

import SwiftUI

struct RecipeView: View {
    let recipe: Recipe
    @Environment(\.dismiss) var dismiss
    @State private var currentStepIndex = 0
    
    // Change this to your backend URL
    private let backendUrl = "https://web-production-11711.up.railway.app"

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Rotated TabView for Vertical Paging
                TabView(selection: $currentStepIndex) {
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                        StepFullScreenView(
                            step: step,
                            index: index,
                            totalSteps: recipe.steps.count,
                            backendUrl: backendUrl,
                            screenSize: geometry.size
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .rotationEffect(.degrees(-90)) // Rotate content back to normal
                        .tag(index)
                    }
                }
                .frame(width: geometry.size.height, height: geometry.size.width) // Swap dimensions for Vertical Paging
                .rotationEffect(.degrees(90), anchor: .center) // Rotate TabView
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                .edgesIgnoringSafeArea(.all)
                
                // Top Overlay: Progress Bar and Controls
                VStack {
                    // Progress Bar
                    HStack(spacing: 4) {
                        ForEach(0..<recipe.steps.count, id: \.self) { index in
                            Capsule()
                                .fill(index <= currentStepIndex ? Color.orange : Color.gray.opacity(0.5))
                                .frame(height: 4)
                                .animation(.easeInOut, value: currentStepIndex)
                        }
                    }
                    .padding(.top, 60) // Extra padding for Dynamic Island/Notch
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
        .edgesIgnoringSafeArea(.all) // Ensure GeometryReader sees full screen
        .navigationBarHidden(true)
        .statusBar(hidden: true)
    }
}

struct StepFullScreenView: View {
    let step: Step
    let index: Int
    let totalSteps: Int
    let backendUrl: String
    let screenSize: CGSize // Pass screen size to handle layout better
    
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
                        .ignoresSafeArea(.all)
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
                    .ignoresSafeArea()
            }
            
            // Gradient Overlay
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.8), .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: screenSize.height * 0.6) // Limit height to bottom 60%
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom) // Align to bottom
            .ignoresSafeArea()
            
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
                    .cornerRadius(8)
                
                // Description
                Text(step.description)
                    .font(.title3) // Slightly smaller for safety
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
            .padding(.horizontal, 30) // Increased horizontal padding to prevent cutoff
            .padding(.bottom, 50) // Increased bottom padding for safe area
            .frame(width: screenSize.width, alignment: .leading) // Ensure full width usage but aligned left
        }
        .frame(width: screenSize.width, height: screenSize.height)
        .ignoresSafeArea()
    }
}
