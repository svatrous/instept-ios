import SwiftUI

struct StatBox: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .font(.system(size: 20))
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
                .fontWeight(.bold)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
