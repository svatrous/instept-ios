import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 20) {
            // Illustration
            illustrationView
                .frame(maxWidth: .infinity)
                .frame(height: 350) // Fixed height to avoid UIScreen.main deprecation warning
                .padding(.horizontal, 20)
            
            // Title with highlighted word
            highlightedTitle
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            // Subtitle
            Text(page.subtitle)
                .font(.callout)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 30)
            
            Spacer()
        }
    }
    
    // MARK: - Highlighted Title
    
    private var highlightedTitle: some View {
        let parts = page.title.components(separatedBy: page.highlightedWord)
        
        return Group {
            if parts.count == 2 {
                (Text(parts[0])
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                 +
                 Text(page.highlightedWord)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color(red: 0.92, green: 0.60, blue: 0.28))
                 +
                 Text(parts[1])
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                )
            } else {
                Text(page.title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
    
    // MARK: - Illustration Views
    
    @ViewBuilder
    private var illustrationView: some View {
        switch page.illustrationType {
        case .videoStruggle:
            VideoStruggleIllustration()
        case .reelsToRecipes:
            ReelsToRecipesIllustration()
        case .saveFavorites:
            SaveFavoritesIllustration()
        case .pushNotification:
            PushNotificationIllustration() // Ensure this is available
        }
    }
}
