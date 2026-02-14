import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var user: User?
    
    // User Preferences (Persisted)
    @Published var measurementSystem: String {
        didSet {
            UserDefaults.standard.set(measurementSystem, forKey: "measurementSystem")
        }
    }
    
    @Published var recipeLanguage: String {
        didSet {
            UserDefaults.standard.set(recipeLanguage, forKey: "recipeLanguage")
        }
    }
    
    @Published var pushNotificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(pushNotificationsEnabled, forKey: "pushNotificationsEnabled")
        }
    }
    
    init() {
        // Initialize from UserDefaults
        self.measurementSystem = UserDefaults.standard.string(forKey: "measurementSystem") ?? "Metric"
        self.recipeLanguage = UserDefaults.standard.string(forKey: "recipeLanguage") ?? "English (US)"
        // specific check for nil to default to true
        if UserDefaults.standard.object(forKey: "pushNotificationsEnabled") == nil {
            self.pushNotificationsEnabled = true
        } else {
            self.pushNotificationsEnabled = UserDefaults.standard.bool(forKey: "pushNotificationsEnabled")
        }
        
        // Mock User for now
        self.user = User(
            id: "user_123",
            name: "Marcus Chen",
            email: "marcus.chen@chefmail.com",
            avatarUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuD5c8m00aiUYxSON-9ULmRUv64TOYiTiyHU0icTp2NhHQ0tKzKdGTndcgL3cCm0D5Y7oWjOz8mWJStn3zNJn-wYSe6bnH-wzWnZuWRmLw3TwvuF5tVoDrl_9zTBtfB4XXjbFyusbkyYhC4gsm5APyQo4rQk7Ik9wCMANOeaQB3WshFymtDpXt9Qd2l_QxG-D42LvZl3QLyfzO3US2eU8MK2olBMgdIVV47omBXcDwRWhSDBt-LJ-KMkZl3sTT37T5Po6Ee3YXaP6w"
        )
    }
    
    func toggleMeasurementSystem() {
        measurementSystem = measurementSystem == "Metric" ? "Imperial" : "Metric"
    }
    
    func logout() {
        // Implement logout logic
        print("Logging out...")
    }
    
    func deleteAccount() {
        // Implement delete account logic
        print("Deleting account...")
    }
    
    func rateApp() {
        // Open App Store review page
        print("Rate app...")
    }
    
    func contactSupport() {
        // Open email or support page
        print("Contact support...")
    }
    
    func openTerms() {
        // Open Terms of Use URL
        print("Open Terms...")
    }
    
    func openPrivacy() {
        // Open Privacy Policy URL
        print("Open Privacy...")
    }
    
    func manageSubscription() {
        // Open subscription management
        print("Manage subscription...")
    }
}
