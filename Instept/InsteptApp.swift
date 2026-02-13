import SwiftUI
import FirebaseCore

import UserNotifications
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
    // Register for remote notifications
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
    )
    application.registerForRemoteNotifications()
    
    // Set Messaging delegate
    Messaging.messaging().delegate = self
    
    #if DEBUG
    do {
        // Comment out logout for now to test flow without re-login
        // try Auth.auth().signOut()
        // UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
        // print("DEBUG: User signed out and onboarding reset.")
    } catch {
        print("DEBUG: Sign out failed: \(error.localizedDescription)")
    }
    #endif
    return true
  }
  
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
  }
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
      if let token = fcmToken {
          UserDefaults.standard.set(token, forKey: "fcmToken")
      }
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
