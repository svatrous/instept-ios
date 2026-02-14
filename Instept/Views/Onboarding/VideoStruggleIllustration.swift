import SwiftUI

struct VideoStruggleIllustration: View {
    @State private var questionBounce = false
    
    // Image URLs from the HTML mockup
    private let mainImageUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuC2NP00m1Df1m7ohNGKZ75N85kBOGtmXlE9h7orai90wazDLXjONSEJAcR3WucL9-QhwTUeEvSiVUN2ys-skV642BT2Pd06SB6_yxlUgH3KxZ4Tm4suV1VJF58CXeIxcCW-sXRqP2_h1IJX_FxNn3Fbm8w3EI0AP3s8pEoCJLQfrCghe4-8FEtMTJLJcPeXhjRPSCZvbubXn-lnYuUMuc8QYNLXIHdZRG_OgrATdhLZRqw4JFfrxVVdvBXxbACs1R_x0jd2iCUEMQ"
    private let backCardUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuA1RlId0vmE65RNCfOL8OMLbqUQSKY-uQwHqLmFKrOfntsUwrCK_2qKAO4bHeZeWqY363-PA7UXMJl77jIN_2WcuB7kKgZOxDPbzjdbDfaIYGb7tvFqq_3G_ftPeWT9hHnxSDw6mTMhXPR1ruBzcM7AutT6rAUN0zdd6Jxj1mosvoMnCK07_IvOksHY4Dcnlz_M55UNQy-BrlD1ic0kI-Dow-dNn0liikS2IzyWe4lPtjssHRFLbJyv9Blr0B_AVvt2RaPp_LLiaA"
    private let midCardUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuD3i4K8Z5-QZK1DO2RiwLoK5ILIgELh-x3uzoxrcg0ABAmAxKRhduw1cyF4Gv5VQYq1CrRPJViJR5wnNPdB5tZoXRHNtZbiDrzCHs_dfsZqQW65uantTohVviJ5jQufWDMvwbMknLmRlcPs0XX7XDATacRdHPSI1mVTFE5Ydn6GxqBrgwqLAMiKAQOBl4SLRGWaxUrhzuRYEsGZ4KynfyepqTPRAKXD3On-fOjVbM52PHhOelTsUQfGDnlJbkOJGTJ43IyKN16FDA"
    private let avatarUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuAc7gchxKgBy-AEqXhKp_IhdkEaEFbHL3ycPo4RqyrjNr7itE_yfD_4p20npyKC0gg20eMBdGbBVTlGmi8RrK4KtDgI99eX2Yzy1y1FqlJyjHUV1O7oBnD2MyuqaNuQDZACz5RmpkEhY5OfMplbBHuLhB1GFud6RWAS1iin8xOFTE5gDFBmy59hCitsPBXKGwb3qqHbjvY_-2r1fZjh6EuPwMeYFsYQItASZHzdr_3nulMbKMsMMAvKneosXGT_sBI3Dq7kWbihIQ"
    
    var body: some View {
        ZStack {
            // Floating decorations
            // Bookmark
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.17, green: 0.13, blue: 0.10))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                )
                .rotationEffect(.degrees(-12))
                .offset(x: -120, y: -80)
                .opacity(0.6)
            
            // Heart
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.17, green: 0.13, blue: 0.10))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red.opacity(0.7))
                        .font(.caption2)
                )
                .rotationEffect(.degrees(12))
                .offset(x: 110, y: 100)
                .opacity(0.6)
            
            // Card 3 (Back)
            CachedAsyncImage(url: URL(string: backCardUrl)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color(red: 0.2, green: 0.2, blue: 0.2)
            }
            .frame(width: 220, height: 280)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .opacity(0.5)
            .rotationEffect(.degrees(-6))
            .offset(x: -8, y: -8)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
                    .frame(width: 220, height: 280)
                    .rotationEffect(.degrees(-6))
                    .offset(x: -8, y: -8)
            )
            
            // Card 2 (Middle)
            ZStack {
                CachedAsyncImage(url: URL(string: midCardUrl)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(red: 0.25, green: 0.25, blue: 0.25)
                }
                .frame(width: 230, height: 290)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .opacity(0.7)
                
                // Bottom gradient text bars
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Capsule().fill(Color.gray.opacity(0.5)).frame(width: 100, height: 6)
                        Capsule().fill(Color.gray.opacity(0.4)).frame(width: 70, height: 6)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                    )
                }
                .frame(width: 230, height: 290)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .rotationEffect(.degrees(3))
            .offset(x: -4, y: -4)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    .frame(width: 230, height: 290)
                    .rotationEffect(.degrees(3))
                    .offset(x: -4, y: -4)
            )
            
            // Card 1 (Front - Main Focus)
            ZStack {
                CachedAsyncImage(url: URL(string: mainImageUrl)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(red: 0.17, green: 0.13, blue: 0.10)
                }
                .frame(width: 240, height: 310)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Dark gradient overlay
                VStack {
                    Spacer()
                    Rectangle()
                    .fill(
                        LinearGradient(colors: [.clear, .clear, .black.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(height: 200)
                }
                .frame(width: 240, height: 310)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Pause button in center
                Circle()
                    .fill(Color.black.opacity(0.4))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "pause.fill")
                            .foregroundColor(.white)
                            .font(.body)
                    )
                    .background(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .frame(width: 44, height: 44)
                    )
                    .offset(y: -30)
                
                // Bottom overlay: avatar, text, progress
                VStack(alignment: .leading, spacing: 6) {
                    Spacer()
                    
                    // Avatar + Name
                    HStack(spacing: 8) {
                        CachedAsyncImage(url: URL(string: avatarUrl)) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle().fill(Color.gray.opacity(0.4))
                        }
                        .frame(width: 28, height: 28)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.orange, lineWidth: 1.5))
                        
                        Text("Chef_Anna")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    
                    Text("Wait for the secret ingredient... 🤫 #cooking")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(1)
                    
                    // Progress bar
                    VStack(spacing: 3) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 3)
                                Capsule()
                                    .fill(Color.orange)
                                    .frame(width: geo.size.width * 0.65, height: 3)
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 8, height: 8)
                                    .offset(x: geo.size.width * 0.65 - 4)
                            }
                        }
                        .frame(height: 8)
                        
                        HStack {
                            Text("0:42")
                                .font(.system(size: 8, design: .monospaced))
                                .foregroundColor(.white.opacity(0.5))
                            Spacer()
                            Text("1:00")
                                .font(.system(size: 8, design: .monospaced))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
                .padding(14)
                .frame(width: 240, height: 310, alignment: .bottomLeading)
            }
            .rotationEffect(.degrees(-2))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    .frame(width: 240, height: 310)
                    .rotationEffect(.degrees(-2))
            )
            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
            
            // Floating question mark badge — bouncing
            Circle()
                .fill(Color(red: 0.92, green: 0.60, blue: 0.28))
                .frame(width: 44, height: 44)
                .overlay(
                    Text("?")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
                .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                .offset(x: 115, y: -90)
                .offset(y: questionBounce ? -8 : 8)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: questionBounce
                )
                .onAppear { questionBounce = true }
        }
    }
}
