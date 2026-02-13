import SwiftUI
import UserNotifications

struct PushNotificationIllustration: View {
    @State private var bellBounce = false
    @State private var checkPulse = false
    @State private var menuRotate = false
    
    var body: some View {
        ZStack {
            // Center Glow
            Circle()
                .fill(Color("primary").opacity(0.2))
                .frame(width: 180, height: 180)
                .blur(radius: 40)
            
            Circle()
                .fill(Color.orange.opacity(0.1))
                .frame(width: 120, height: 120)
                .blur(radius: 30)
            
            // Main Bell Container
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 140, height: 140)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.05), lineWidth: 1)
                    )
                
                Image(systemName: "bell.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.3), radius: 15, x: 0, y: 0)
                
                // Notification Dot
                Circle()
                    .fill(Color("primary"))
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .offset(x: 24, y: -24)
                    .scaleEffect(bellBounce ? 1.2 : 1.0)
                    .animation(
                        .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                        value: bellBounce
                    )
            }
            .scaleEffect(1.2)
            
            // Floating Element 1: Restaurant Menu (Top Right)
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 50, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                
                Image(systemName: "list.bullet.rectangle.portrait.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color("primary"))
            }
            .rotationEffect(.degrees(12))
            .offset(x: 60, y: -70)
            .rotationEffect(.degrees(menuRotate ? 5 : -5))
            .animation(
                .easeInOut(duration: 3.0).repeatForever(autoreverses: true),
                value: menuRotate
            )
            
            // Floating Element 2: Check Circle (Bottom Left)
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 56, height: 56)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.green)
            }
            .rotationEffect(.degrees(-12))
            .offset(x: -70, y: 60)
            .scaleEffect(checkPulse ? 1.1 : 0.95)
            .animation(
                .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                value: checkPulse
            )
        }
        .onAppear {
            bellBounce = true
            checkPulse = true
            menuRotate = true
        }
    }
}

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

