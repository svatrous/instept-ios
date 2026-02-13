import SwiftUI
import AuthenticationServices

// MARK: - Onboarding Data Model

struct OnboardingPage {
    let title: String
    let highlightedWord: String
    let subtitle: String
    let illustrationType: IllustrationType
    
    enum IllustrationType {
        case videoStruggle
        case reelsToRecipes
        case saveFavorites
        case pushNotification
    }
}

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

// MARK: - Individual Page View

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
            PushNotificationIllustration()
        }
    }
}

// MARK: - Screen 1: Video Struggle Illustration

struct VideoStruggleIllustration: View {
    @State private var questionBounce = false
    
    // Image URLs from the HTML mockup
    private let mainImageUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuC2NP00m1Df1m7ohNGKZ75N85kBOGtmXlE9h7orai90wazDLXjONSEJAcR3WucL9-QhwTUeEvSiVUN2ys-skV642BT2Pd06SB6_yxlUgH3KxZ4Tm4suV1VJF58CXeIxcCW-sXRqP2_h1IJX_FxNn3Fbm8w3EI0AP3s8pEoCJLQfrCghe4-8FEtMTJLJcPeXhjRPSCZvbubXn-lnYuUMuc8QYNLXIHdZRG_OgrATdhLZRqw4JFfrxVVdvBXxbACs1R_x0jd2iCUEMQ"
    private let backCardUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuA1RlId0vmE65RNCfOL8OMLbqUQSKY-uQwHqLmFKrOfntsUwrCK_2qKAO4bHeZeWqY363-PA7UXMJl77jIN_2WcuB7kKgZOxDPbzjdbDfaIYGb7tvFqq_3G_ftPeWT9hHnxSDw6mTMhXPR1ruBzcM7AutT6rAUN0zdd6Jxj1mosvoMnCK07_IvOksHY4Dcnlz_M55UNQy-BrlD1ic0kI-Dow-dNn0liikS2IzyWe4lPtjssHRFLbJyv9Blr0B_AVvt2RaPp_LLiaA"
    private let midCardUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuD3i4K8Z5-QZK1DO2RiwLoK5ILIgELh-x3uzoxrcg0ABAmAxKRhduw1cyF4Gv5VQYq1CrRPJViJR5wnNPdB5tZoXRHNtZbiDrzCHs_dfsZqQW65uantTohVviJ5jQufWDMvwbMknLmRlcPs0XX7XDATacRdHPSI1mVTFE5Ydn6GxqBrgwqLAMiKAQOBl4SLRGWaxUrhzuRYEsGZ4KynfyepqTPRAKXD3On-fOjVbM52PHhOelTsUQfGDnlJbkOJGTJ43IyKN16FDA"
    private let avatarUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuAc7gchxKgBy-AEqXhKp_IhdkEaEFbHL3ycPo4RqyrjNr7itE_yfD_4p20npyKC0gg20eMBdGbBVTlGmi8RrK4KtDgI99eX2Yzy1y1FqlJyjHUV1O7oBnD2MyuqaNuQDZACz5RmpkEhY5OfMplbBHuLhB1GFud6RWAS1iin8xOFTE5gDFBmy59hCitsPBXKGwb3qqHbjvY_-2r1fZjh6EuPwMeYFsYQItASZHzdr_3nulMbKMsMMAvKneosXGT_sBI3Dq7kWbihIQ"
    
    var body: some View {
        ZStack {
            // Floating decorations
            // Bookmark
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.17, green: 0.13, blue: 0.10))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                )
                .rotationEffect(.degrees(-12))
                .offset(x: -120, y: -80)
                .opacity(0.6)
            
            // Heart
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.17, green: 0.13, blue: 0.10))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red.opacity(0.7))
                        .font(.caption2)
                )
                .rotationEffect(.degrees(12))
                .offset(x: 110, y: 100)
                .opacity(0.6)
            
            // Card 3 (Back)
            AsyncImage(url: URL(string: backCardUrl)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color(red: 0.2, green: 0.2, blue: 0.2)
            }
            .frame(width: 220, height: 280)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .opacity(0.5)
            .rotationEffect(.degrees(-6))
            .offset(x: -8, y: -8)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
                    .frame(width: 220, height: 280)
                    .rotationEffect(.degrees(-6))
                    .offset(x: -8, y: -8)
            )
            
            // Card 2 (Middle)
            ZStack {
                AsyncImage(url: URL(string: midCardUrl)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(red: 0.25, green: 0.25, blue: 0.25)
                }
                .frame(width: 230, height: 290)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .opacity(0.7)
                
                // Bottom gradient text bars
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Capsule().fill(Color.gray.opacity(0.5)).frame(width: 100, height: 6)
                        Capsule().fill(Color.gray.opacity(0.4)).frame(width: 70, height: 6)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                    )
                }
                .frame(width: 230, height: 290)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .rotationEffect(.degrees(3))
            .offset(x: -4, y: -4)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    .frame(width: 230, height: 290)
                    .rotationEffect(.degrees(3))
                    .offset(x: -4, y: -4)
            )
            
            // Card 1 (Front - Main Focus)
            ZStack {
                AsyncImage(url: URL(string: mainImageUrl)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(red: 0.17, green: 0.13, blue: 0.10)
                }
                .frame(width: 240, height: 310)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Dark gradient overlay
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(
                            LinearGradient(colors: [.clear, .clear, .black.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(height: 200)
                }
                .frame(width: 240, height: 310)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Pause button in center
                Circle()
                    .fill(Color.black.opacity(0.4))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "pause.fill")
                            .foregroundColor(.white)
                            .font(.body)
                    )
                    .background(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .frame(width: 44, height: 44)
                    )
                    .offset(y: -30)
                
                // Bottom overlay: avatar, text, progress
                VStack(alignment: .leading, spacing: 6) {
                    Spacer()
                    
                    // Avatar + Name
                    HStack(spacing: 8) {
                        AsyncImage(url: URL(string: avatarUrl)) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle().fill(Color.gray.opacity(0.4))
                        }
                        .frame(width: 28, height: 28)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.orange, lineWidth: 1.5))
                        
                        Text("Chef_Anna")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    
                    Text("Wait for the secret ingredient... 🤫 #cooking")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(1)
                    
                    // Progress bar
                    VStack(spacing: 3) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 3)
                                Capsule()
                                    .fill(Color.orange)
                                    .frame(width: geo.size.width * 0.65, height: 3)
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 8, height: 8)
                                    .offset(x: geo.size.width * 0.65 - 4)
                            }
                        }
                        .frame(height: 8)
                        
                        HStack {
                            Text("0:42")
                                .font(.system(size: 8, design: .monospaced))
                                .foregroundColor(.white.opacity(0.5))
                            Spacer()
                            Text("1:00")
                                .font(.system(size: 8, design: .monospaced))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
                .padding(14)
                .frame(width: 240, height: 310, alignment: .bottomLeading)
            }
            .rotationEffect(.degrees(-2))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    .frame(width: 240, height: 310)
                    .rotationEffect(.degrees(-2))
            )
            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
            
            // Floating question mark badge — bouncing
            Circle()
                .fill(Color(red: 0.92, green: 0.60, blue: 0.28))
                .frame(width: 44, height: 44)
                .overlay(
                    Text("?")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
                .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                .offset(x: 115, y: -90)
                .offset(y: questionBounce ? -8 : 8)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: questionBounce
                )
                .onAppear { questionBounce = true }
        }
    }
}

// MARK: - Screen 2: Reels to Recipes Illustration

struct ReelsToRecipesIllustration: View {
    @State private var magicBounce = false
    @State private var savedBounce = false
    @State private var chevronPulse = false
    
    private let videoImageUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuAd4Li8CX1CldzqePqlFY4EIGsHueHS-oe4WlTg6cICBj9GaR0PiMuo6l0ClOVhZZSrJT75QFaKnhiaNDGMyHuibKN5ebVwkbQaPht-678Ei0RWa1IiPLB3iEejtkqjf4pjfTiSucdNTgzA35LJj94qZIqNPFDqrq--OzpX115Faa08Vm0R8wXIFDWclBbIQGQ8U-DyEaXTcs_QNAIv6W1-9nuhTFWackNLyIwM7QKlokC3tQDZU3dGc2RulXiYnOYBFRHmKGeUKA"
    
    var body: some View {
        ZStack {
            // Phone mockup — scaled down to fit
            VStack(spacing: 0) {
                // Video section (top half)
                ZStack {
                    AsyncImage(url: URL(string: videoImageUrl)) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        LinearGradient(
                            colors: [Color(red: 0.5, green: 0.4, blue: 0.2), Color(red: 0.35, green: 0.25, blue: 0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                    .frame(width: 200, height: 150)
                    .clipped()
                    
                    // Dark overlay
                    Color.black.opacity(0.35)
                    
                    VStack {
                        HStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.black.opacity(0.4))
                                    .frame(width: 26, height: 26)
                                Image(systemName: "wand.and.stars")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 10))
                            }
                        }
                        .padding(8)
                        
                        Circle()
                            .fill(Color.black.opacity(0.4))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .font(.caption2)
                            )
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image(systemName: "heart")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.caption2)
                                Image(systemName: "bookmark")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.caption2)
                            }
                            .padding(6)
                        }
                    }
                    .frame(width: 200, height: 150)
                }
                .frame(width: 200, height: 150)
                .clipped()
                
                // Orange divider with pulsing chevron
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(colors: [Color.orange.opacity(0.9), Color.orange], startPoint: .top, endPoint: .bottom)
                        )
                    
                    Image(systemName: "chevron.compact.down")
                        .foregroundColor(.white)
                        .font(.caption)
                        .opacity(chevronPulse ? 0.5 : 1.0)
                        .animation(
                            .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                            value: chevronPulse
                        )
                }
                .frame(height: 28)
                
                // Recipe card section (bottom half)
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Spacer()
                        Capsule()
                            .fill(Color.gray.opacity(0.25))
                            .frame(width: 30, height: 3)
                        Spacer()
                    }
                    .padding(.top, 6)
                    
                    HStack(spacing: 6) {
                        AsyncImage(url: URL(string: videoImageUrl)) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 6).fill(Color.orange.opacity(0.2))
                        }
                        .frame(width: 36, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Capsule().fill(Color(red: 0.2, green: 0.2, blue: 0.25)).frame(width: 80, height: 6)
                            Capsule().fill(Color.orange.opacity(0.6)).frame(width: 100, height: 5)
                        }
                        
                        Spacer()
                        
                        Text("Saved")
                            .font(.system(size: 7, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Color(red: 0.2, green: 0.2, blue: 0.25))
                            .cornerRadius(3)
                    }
                    .padding(.horizontal, 8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Capsule().fill(Color.gray.opacity(0.2)).frame(height: 5)
                        Capsule().fill(Color.gray.opacity(0.2)).frame(width: 120, height: 5)
                    }
                    .padding(.horizontal, 8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(1...3, id: \.self) { num in
                            HStack(spacing: 4) {
                                Text("\(num)")
                                    .font(.system(size: 6, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 12, height: 12)
                                    .background(Color.green.opacity(0.8))
                                    .clipShape(Circle())
                                Capsule().fill(Color.gray.opacity(0.2)).frame(height: 5)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    Spacer()
                }
                .frame(width: 200, height: 130)
                .background(Color.white)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.08), lineWidth: 3)
            )
            .shadow(color: .black.opacity(0.5), radius: 24, x: 0, y: 12)
            .rotationEffect(.degrees(-5))
            
            // "Magic!" floating badge — bouncing
            HStack(spacing: 4) {
                Image(systemName: "wand.and.stars")
                    .foregroundColor(.orange)
                    .font(.caption2)
                Text("Magic!")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color(red: 0.17, green: 0.13, blue: 0.10))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
            .rotationEffect(.degrees(15))
            .offset(x: 110, y: -80)
            .offset(y: magicBounce ? -6 : 6)
            .animation(
                .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                value: magicBounce
            )
            
            // "Saved" floating badge — bouncing
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.caption2)
                Text("Saved")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color(red: 0.17, green: 0.13, blue: 0.10))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
            .rotationEffect(.degrees(-10))
            .offset(x: -100, y: 80)
            .offset(y: savedBounce ? -6 : 6)
            .animation(
                .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                value: savedBounce
            )
        }
        .onAppear {
            magicBounce = true
            savedBounce = true
            chevronPulse = true
        }
        .scaleEffect(0.9)
    }
}

// MARK: - Screen 3: Save Favorites Illustration

struct SaveFavoritesIllustration: View {
    @State private var ringPulse = false
    @State private var syncedBounce = false
    @State private var secureBounce = false
    
    var body: some View {
        ZStack {
            // Outer pulsing ring
            Circle()
                .stroke(Color.white.opacity(ringPulse ? 0.08 : 0.03), lineWidth: 2)
                .frame(width: 260, height: 260)
                .scaleEffect(ringPulse ? 1.05 : 0.95)
                .animation(
                    .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                    value: ringPulse
                )
            
            // Inner dark circle
            Circle()
                .fill(Color(red: 0.10, green: 0.08, blue: 0.06))
                .frame(width: 220, height: 220)
                .overlay(
                    Circle()
                        .stroke(Color(red: 0.17, green: 0.13, blue: 0.10), lineWidth: 4)
                )
                .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
            
            // Lock + person icon — overlapping at bottom-right like mockup
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "lock")
                    .font(.system(size: 54, weight: .medium))
                    .foregroundColor(Color(red: 0.92, green: 0.60, blue: 0.28))
                
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(Color(red: 0.92, green: 0.60, blue: 0.28))
                    .background(
                        Circle()
                            .fill(Color(red: 0.10, green: 0.08, blue: 0.06))
                            .frame(width: 40, height: 40)
                    )
                    .offset(x: 8, y: 8)
            }
            
            // "Synced" badge — bouncing (3s cycle)
            HStack(spacing: 6) {
                Image(systemName: "checkmark.icloud.fill")
                    .foregroundColor(.green)
                    .font(.caption)
                Text("Synced")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(red: 0.17, green: 0.14, blue: 0.11))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
            .rotationEffect(.degrees(10))
            .offset(x: 90, y: -80)
            .offset(y: syncedBounce ? -6 : 6)
            .animation(
                .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                value: syncedBounce
            )
            
            // "Secure" badge — bouncing (4s cycle)
            HStack(spacing: 6) {
                Image(systemName: "shield.fill")
                    .foregroundColor(.blue)
                    .font(.caption)
                Text("Secure")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(red: 0.17, green: 0.14, blue: 0.11))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
            .rotationEffect(.degrees(-5))
            .offset(x: -85, y: 60)
            .offset(y: secureBounce ? -5 : 5)
            .animation(
                .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                value: secureBounce
            )
        }
        .onAppear {
            ringPulse = true
            syncedBounce = true
            secureBounce = true
        }
    }
}
