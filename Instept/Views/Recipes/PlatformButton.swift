import SwiftUI

struct PlatformButton: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray.opacity(0.6))
                .tracking(1)
        }
    }
}
