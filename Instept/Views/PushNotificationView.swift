import SwiftUI
import UserNotifications



// Wrapper for preview compatibility if needed, though now mostly unused in main flow
struct PushNotificationView: View {
    var onContinue: () -> Void
    
    var body: some View {
        VStack {
            PushNotificationIllustration()
                .frame(height: 360)
            Spacer()
            Button("Continue", action: onContinue)
        }
        .background(Color("background-dark"))
    }
}

