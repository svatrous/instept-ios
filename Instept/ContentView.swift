import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var urlInput: String = ""
    @State private var isShowingRecipe = false

    
    var body: some View {
        VStack(spacing: 20) {
            Text("Instept")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.purple)
            
            Text("Paste an Instagram Reel URL to get the recipe")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("https://instagram.com/reel/...", text: $urlInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
            
            Button(action: {
                viewModel.analyzeMetadata(url: urlInput)
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Analyze Recipe")
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(viewModel.isLoading || urlInput.isEmpty)
            .padding(.horizontal)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding()
            }
            
            Spacer()
            
            // Navigation to RecipeOverview is handled by parent or replaced by sheet?
            // Actually, if presented as sheet, we might want to navigate within the sheet 
            // OR dismiss and show recipe. 
            // For MVP, simplest is to keep NavigationLink but ensure we have NavigationView wrapping this ContentView in the parent (HomeView sheet).
            // HomeView sheet: .sheet(isPresented: ...) { ContentView() } -> This needs a NavigationView inside if we want push nav.
            // Converting ContentView to NOT have NavigationView, so we can wrap it if needed or use it as subview.
            
            NavigationLink(
                destination: Group {
                    if let recipe = viewModel.recipe {
                        RecipeOverviewView(recipe: recipe)
                    } else {
                        EmptyView()
                    }
                },
                isActive: $isShowingRecipe,
                label: { EmptyView() }
            )
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline) // Optional
        .onChange(of: viewModel.recipe != nil) { hasRecipe in
             if hasRecipe {
                 isShowingRecipe = true
             }
        }
    }
}
