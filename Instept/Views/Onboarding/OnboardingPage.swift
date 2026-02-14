import SwiftUI

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
