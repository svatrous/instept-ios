import SwiftUI

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
