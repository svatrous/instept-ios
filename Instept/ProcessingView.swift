import SwiftUI

struct ProcessingView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Animation states
    @State private var pulseSlow = false
    @State private var floatAnim = false
    @State private var sparkle1 = false
    @State private var sparkle2 = false
    @State private var sparkle3 = false
    
    @Binding var contentHeight: CGFloat
    
    var onGotIt: () -> Void = {}
    
    var body: some View {
        ZStack {
            // Background Layer
            Color("background-dark")
                .ignoresSafeArea()
            
            // Background Gradient Overlay
            VStack {
                LinearGradient(
                    colors: [Color("primary").opacity(0.05), .clear],
                    startPoint: .top,
                    endPoint: .center
                )
                .frame(height: 300)
                Spacer()
            }
            .ignoresSafeArea()
            
            // Background Blur Blob 1
            Circle()
                .fill(Color("primary").opacity(0.1))
                .frame(width: 320, height: 320)
                .blur(radius: 80)
                .offset(x: 0, y: -250)
            
            VStack(spacing: 0) {
                // Handle indicator
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 48, height: 6)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                
                // Main Illustration Area
                ZStack {
                    // Center Glow (Pulse Slow)
                    Circle()
                        .fill(Color("primary").opacity(0.05))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .scaleEffect(pulseSlow ? 1.1 : 0.9)
                        .opacity(pulseSlow ? 0.8 : 0.5)
                        .animation(
                            .easeInOut(duration: 4.0).repeatForever(autoreverses: true),
                            value: pulseSlow
                        )
                    
                    // Sparkles
                    Image(systemName: "sparkles") // auto_awesome
                        .font(.system(size: 24))
                        .foregroundColor(Color("primary").opacity(0.6))
                        .offset(x: 80, y: -60)
                        .scaleEffect(sparkle1 ? 1.2 : 0.8)
                        .opacity(sparkle1 ? 1.0 : 0.5)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(0.2), value: sparkle1)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color("primary").opacity(0.4))
                        .offset(x: -60, y: 80)
                        .scaleEffect(sparkle2 ? 1.2 : 0.8)
                        .opacity(sparkle2 ? 1.0 : 0.5)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(1.5), value: sparkle2)
                    
                    Image(systemName: "sparkle") // blur_on equivalent
                        .font(.system(size: 20))
                        .foregroundColor(Color.orange.opacity(0.3))
                        .offset(x: -80, y: -50)
                        .scaleEffect(sparkle3 ? 1.2 : 0.8)
                        .opacity(sparkle3 ? 1.0 : 0.5)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(0.8), value: sparkle3)
                    
                    // Floating "Magic Button" Icon
                    ZStack {
                        // Outer rotating border 1
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color("primary").opacity(0.2), lineWidth: 2)
                            .frame(width: 144, height: 144)
                            .rotationEffect(.degrees(12))
                            .scaleEffect(1.1)
                            .blur(radius: 1)
                        
                        // Outer rotating border 2
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            .frame(width: 144, height: 144)
                            .rotationEffect(.degrees(-6))
                            .scaleEffect(1.05)
                        
                        // Main container
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [Color("neutral-surface-dark"), Color("neutral-surface-darker")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 144, height: 144)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                        
                        // Inner gradient overlay
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [Color("primary").opacity(0.2), .clear],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(width: 144, height: 144)
                            .opacity(0.5)

                        // Icon with Gradient Text effect
                        Image(systemName: "wand.and.stars") // magic_button approximate
                            .font(.system(size: 64))
                            .overlay(
                                LinearGradient(
                                    colors: [Color("primary"), Color.orange.opacity(0.6), .white],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .mask(
                                    Image(systemName: "wand.and.stars")
                                        .font(.system(size: 64))
                                )
                            )
                            .foregroundColor(.clear) // Hide original color to show gradient mask
                            .shadow(color: Color("primary").opacity(0.4), radius: 10, x: 0, y: 5)
                            
                    }
                    .offset(y: floatAnim ? -15 : 15)
                    .animation(
                        .easeInOut(duration: 3.0).repeatForever(autoreverses: true),
                        value: floatAnim
                    )
                }
                .frame(height: 300)
                .padding(.bottom, 32)
                
                // Text Content
                VStack(spacing: 12) {
                    Text("We're on it!")
                        .font(.custom("PlusJakartaSans-Bold", size: 28)) // Fallback
                        .fontWeight(.bold) // Fallback
                        .foregroundColor(.white)
                        .tracking(-0.5)
                    
                    Text("Our AI is busy turning that video into a perfect recipe. You can close this app—we will send you a push notification the moment it's ready!")
                        .font(.body)
                        .foregroundColor(Color(uiColor: .lightGray))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 32)
                        .fixedSize(horizontal: false, vertical: true) // Ensure wraps correctly
                }
                .padding(.bottom, 40)
                
                // Button
                Button(action: {
                    onGotIt()
                    dismiss()
                }) {
                    Text("Got it")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color("primary"))
                        .cornerRadius(16)
                        .shadow(color: Color("primary").opacity(0.25), radius: 15, x: 0, y: 0) // shadow-glow
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24) // Added bottom padding instead of spacer
            }
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            contentHeight = geo.size.height
                        }
                        .onChange(of: geo.size.height) { newHeight in
                            contentHeight = newHeight
                        }
                }
            )
        }
        .onAppear {
            pulseSlow = true
            sparkle1 = true
            sparkle2 = true
            sparkle3 = true
            floatAnim = true
        }
    }
}

#Preview {
    ProcessingView(contentHeight: .constant(600))
}
