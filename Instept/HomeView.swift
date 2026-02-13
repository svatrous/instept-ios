import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingAddRecipe = false
    
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
            .sheet(isPresented: $showingAddRecipe) {
                // Determine what to show here. 
                // Currently ContentView is the "Add Recipe" flow.
                // We might want to refactor ContentView into AddRecipeView or similar.
                // For now, let's wrap ContentView's logic or just present a simplified version.
                // But ContentView HAS NavigationView inside, so verify wrapper.
                ContentView() 
            }
            .task {
                await viewModel.fetchData()
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
                            NavigationLink(destination: RecipeOverviewView(recipe: recipe)) {
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
                NavigationLink(destination: RecipeOverviewView(recipe: recipe)) {
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
                        NavigationLink(destination: RecipeOverviewView(recipe: recipe)) {
                            RecipeRow(recipe: recipe)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Subviews

struct RecipeCardSmall: View {
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
            .frame(width: 140, height: 180)
            .clipped()
            
            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.8), .clear]), startPoint: .bottom, endPoint: .center)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(recipe.time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(12)
        }
        .cornerRadius(16)
        .shadow(radius: 4)
        .frame(width: 140, height: 180)
    }
}

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

struct RecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: recipe.hero_image_url ?? recipe.steps.first?.image_url ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 80)
            .cornerRadius(12)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("By \(recipe.author_name)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    Text(recipe.difficulty)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green) // Or dynamic color
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                    
                    Label(recipe.time, systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}
