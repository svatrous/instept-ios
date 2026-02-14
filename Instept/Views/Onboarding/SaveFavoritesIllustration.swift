import SwiftUI

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
