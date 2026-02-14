import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingAddRecipe = false
    @State private var navigatedRecipe: Recipe?
    @State private var isRecipeActive = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background-dark").edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        headerView
                        
                        // Sections
                        myRecipesSection
                        popularSection
                        recentSection
                        
                        // Bottom padding for FAB
                        Color.clear.frame(height: 80)
                    }
                    .padding(.bottom, 20)
                }
                .refreshable {
                    await viewModel.fetchData()
                }
                
                // FAB
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddRecipe = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color("primary"))
                                .clipShape(Circle())
                                .shadow(color: Color("primary").opacity(0.3), radius: 10, x: 0, y: 4)
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationBarHidden(true)
            .background(
                NavigationLink(isActive: $isRecipeActive, destination: {
                    if let recipe = navigatedRecipe {
                        RecipeOverviewView(recipe: recipe, onHome: {
                            isRecipeActive = false
                        })
                    } else {
                        EmptyView()
                    }
                }) { EmptyView() }
            )
            .sheet(isPresented: $showingAddRecipe) {
                ImportRecipeSheet { recipe in
                    navigatedRecipe = recipe
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isRecipeActive = true
                    }
                }
            }
        .task {
            await viewModel.fetchData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RecipeReadyNotification"))) { notification in
            if let recipeId = notification.userInfo?["recipe_id"] as? String {
                Task {
                    do {
                        // 1. Fetch the full recipe
                        let recipe = try await RecipeService.shared.fetchRecipe(id: recipeId)
                        
                        // 2. Auto-save is now handled by backend
                        // UserManager.shared.saveRecipe(recipeId: recipeId)
                        
                        // 3. Refresh user data to update favorites list
                        // viewModel.fetchData() // Optional: might be too heavy?
                        
                        // 4. Navigate
                        await MainActor.run {
                            navigatedRecipe = recipe
                            isRecipeActive = true
                        }
                    } catch {
                        print("Error handling notification recipe: \(error)")
                    }
                }
            }
        }
    }
    }
    
    // MARK: - Components
    
    var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Good Morning,")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Chef") // Use user name if available
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Avatar
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                )
                .overlay(
                    Circle()
                        .stroke(Color("background-dark"), lineWidth: 2)
                        .frame(width: 12, height: 12)
                        .background(Circle().fill(Color("primary")))
                        .offset(x: 16, y: -16)
                )
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
    
    var myRecipesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("My Recipes")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button("See All") {
                    // Navigate to full list
                }
                .font(.subheadline)
                .foregroundColor(Color("primary"))
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // Create New Card
                    Button(action: {
                        showingAddRecipe = true
                    }) {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color("primary").opacity(0.1))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "plus")
                                    .foregroundColor(Color("primary"))
                            }
                            .padding(.bottom, 4)
                            Text("Create New")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("primary"))
                        }
                        .frame(width: 120, height: 160)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("primary").opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5]))
                        )
                    }
                    .padding(.leading, 24)
                    
                    // Recipe Cards
                    if viewModel.isLoading {
                        ProgressView().frame(width: 120, height: 160)
                    } else {
                        ForEach(viewModel.myRecipes) { recipe in
                            Button(action: {
                                navigatedRecipe = recipe
                                isRecipeActive = true
                            }) {
                                RecipeCardSmall(recipe: recipe)
                            }
                        }
                    }
                }
                .padding(.trailing, 24)
            }
        }
    }
    
    var popularSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular Now")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            if viewModel.isLoading {
                ProgressView().frame(height: 200)
            } else if let recipe = viewModel.popularRecipes.first {
                Button(action: {
                    navigatedRecipe = recipe
                    isRecipeActive = true
                }) {
                    RecipeCardLarge(recipe: recipe)
                        .padding(.horizontal)
                }
            }
        }
    }
    
    var recentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recently Added")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                if viewModel.isLoading {
                    ProgressView().padding()
                } else {
                    ForEach(viewModel.recentRecipes) { recipe in
                        Button(action: {
                            navigatedRecipe = recipe
                            isRecipeActive = true
                        }) {
                            RecipeRow(recipe: recipe)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

