import SwiftUI
import AuthenticationServices

// MARK: - Main Onboarding View

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var authManager = AuthenticationManager()

    
    @State private var currentPage = 0
    // Removed showPushScreen state
    
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Tired of scrubbing through videos to cook?",
            highlightedWord: "scrubbing",
            subtitle: "We've all been there: a dozen saved Reels, but you can't find the ingredients or the steps when it's time to cook.",
            illustrationType: .videoStruggle
        ),
        OnboardingPage(
            title: "From Reels to Recipes",
            highlightedWord: "Recipes",
            subtitle: "Import any cooking Reel and we will turn it into a clean, step-by-step recipe saved to your account.",
            illustrationType: .reelsToRecipes
        ),
        OnboardingPage(
            title: "Save Your Favorites",
            highlightedWord: "Favorites",
            subtitle: "Create an account to keep all your imported recipes organized and accessible on any device.",
            illustrationType: .saveFavorites
        ),
        OnboardingPage(
            title: "Stay Notified",
            highlightedWord: "Notified",
            subtitle: "We'll let you know as soon as your Reel has been successfully transformed into a recipe, so you can start cooking right away.",
            illustrationType: .pushNotification
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.13, green: 0.10, blue: 0.07)
                .ignoresSafeArea()
            
            // Warm gradient blobs (from HTML mockups)
            Circle()
                .fill(Color.orange.opacity(0.15))
                .frame(width: 260, height: 260)
                .blur(radius: 80)
                .offset(x: -100, y: -250)
            
            Circle()
                .fill(Color.purple.opacity(0.08))
                .frame(width: 260, height: 260)
                .blur(radius: 80)
                .offset(x: 100, y: 150)
            
            VStack(spacing: 0) {
                Spacer().frame(height: 20)
                
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        if index == currentPage {
                            Capsule()
                                .fill(Color.orange)
                                .frame(width: 24, height: 8)
                        } else {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                .padding(.bottom, 24)
                
                // Bottom button area
                if currentPage == pages.count - 2 { // Page 3 (Index 2): Sign In
                    SignInWithAppleButton(
                        onRequest: authManager.prepareRequest,
                        onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                authManager.handleAuthorization(authorization) {
                                    withAnimation {
                                        currentPage += 1 // Move to Push Screen
                                    }
                                }
                            case .failure(let error):
                                authManager.handleError(error)
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 56)
                    .cornerRadius(16)
                    .shadow(color: Color.white.opacity(0.1), radius: 12, x: 0, y: 6)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    
                } else if currentPage == pages.count - 1 { // Page 4 (Index 3): Push Permissions
                    VStack(spacing: 16) {
                        Button(action: requestPermissions) {
                            Text("Enable Notifications")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color(red: 0.92, green: 0.60, blue: 0.28))
                                .cornerRadius(16)
                                .shadow(color: Color.orange.opacity(0.2), radius: 12, x: 0, y: 6)
                        }
                        
                        Button(action: completeOnboarding) {
                            Text("Maybe Later")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    
                } else { // Page 1 & 2: Next
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    }) {
                        HStack {
                            Text("Next")
                                .font(.headline)
                                .fontWeight(.bold)
                            Image(systemName: "arrow.right")
                                .font(.headline)
                        }
                        .foregroundColor(Color(red: 0.13, green: 0.10, blue: 0.07))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(red: 0.92, green: 0.60, blue: 0.28)) // #eb9947
                        .cornerRadius(16)
                        .shadow(color: Color.orange.opacity(0.2), radius: 12, x: 0, y: 6)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func completeOnboarding() {
        hasCompletedOnboarding = true
    }
    
    private func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications enabled")
            }
            
            DispatchQueue.main.async {
                completeOnboarding()
            }
        }
    }
}
