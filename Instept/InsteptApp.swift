import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    #if DEBUG
    do {
        try Auth.auth().signOut()
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        print("DEBUG: User signed out and onboarding reset.")
    } catch {
        print("DEBUG: Sign out failed: \(error.localizedDescription)")
    }
    #endif
    return true
  }
}

import FirebaseAuth

@main
struct InsteptApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    HomeView()
                } else {
                    OnboardingView()
                }
            }
            .onAppear {
                if Auth.auth().currentUser != nil {
                    UserManager.shared.fetchSavedRecipes()
                }
            }
        }
    }
}
