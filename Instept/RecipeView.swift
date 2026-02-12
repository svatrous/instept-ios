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
                
                TabView(selection: $currentStepIndex) {
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                        StepFullScreenView(
                            step: step,
                            index: index,
                            totalSteps: recipe.steps.count,
                            backendUrl: backendUrl
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .rotationEffect(.degrees(-90)) // Rotate content back to normal
                        .tag(index)
                    }
                }
                .frame(width: geometry.size.height, height: geometry.size.width) // Swap dimensions for vertical
                .rotationEffect(.degrees(90), anchor: .center) // Rotate TabView
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                
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
                    .padding(.top, 50)
                    .padding(.horizontal, 10)
                    
                    // Header Controls
                    HStack {
                        // Recipe Title Pill (Optional)
                        Text(recipe.title)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Capsule())
                        
                        Spacer()
                        
                        // Close Button
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
    }
}

struct StepFullScreenView: View {
    let step: Step
    let index: Int
    let totalSteps: Int
    let backendUrl: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Image
            if let imageUrl = step.image_url, let url = URL(string: "\(backendUrl)\(imageUrl)") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    case .failure(_):
                        Rectangle().fill(Color.gray.opacity(0.3))
                    case .empty:
                        ZStack {
                            Rectangle().fill(Color.black)
                            ProgressView().tint(.white)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .ignoresSafeArea()
            }
            
            // Gradient Overlay for Text Readability
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.6), .black.opacity(0.9)]),
                startPoint: .center,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .frame(height: 400)
            
            // Content
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
                
                // Title (using first sentence or description as title simulation)
                // Since our model only has 'description', we'll just display it prominently.
                // Or if needed, we could extract title in backend. For now, full description.
                
                // We can bold the first sentence if we want to simulate a title
                Text(step.description)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Ensure consistent cuts for even cooking.") // Static tip or extracted tip could go here
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .opacity(0.8)
                
                // Swipe Indicator
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Text("SWIPE FOR NEXT")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.7))
                        Image(systemName: "chevron.up")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding(.top, 20)
            }
            .padding(24)
            .padding(.bottom, 30)
        }
    }
}
