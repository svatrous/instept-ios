import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background-dark").ignoresSafeArea() /* Custom Color required for dark/light mode match*/
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Settings")
                            .font(.custom("PlusJakartaSans-Bold", size: 28))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                    .background(Color.clear)
                    
                    ScrollView {
                        VStack(spacing: 32) {
                            // Profile Section
                            profileSection
                            
                            // Cooking Preferences
                            cookingPreferencesSection
                            
                            // Subscription & System
                            subscriptionSection
                            
                            // Support & Info
                            supportSection
                            
                            // Footer
                            footerSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Sections
    
    private var profileSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                ZStack(alignment: .bottomTrailing) {
                    if let avatarUrl = viewModel.user?.avatarUrl, let url = URL(string: avatarUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.brandPrimary, lineWidth: 2))
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                            .frame(width: 64, height: 64)
                    }
                    
                    Image(systemName: "pencil")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.brandPrimary)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.surfaceDark, lineWidth: 2))
                        .offset(x: 2, y: 2)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.user?.name ?? "User")
                        .font(.custom("PlusJakartaSans-Bold", size: 18))
                        .foregroundColor(.white)
                    
                    Text(viewModel.user?.email ?? "")
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundColor(.slate500)
                }
                
                Spacer()
            }
            .padding(20)
            
            Divider()
                .background(Color.white.opacity(0.05))
            
            Button {
                viewModel.logout()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 16))
                    Text("Log Out")
                        .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                }
                .foregroundColor(.slate200)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
        }
        .background(Color.surfaceDark) // Need to define this color
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
    }
    
    private var cookingPreferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("COOKING PREFERENCES")
                .font(.custom("PlusJakartaSans-Bold", size: 12))
                .foregroundColor(.slate400)
                .padding(.horizontal, 8)
            
            VStack(spacing: 0) {
                // Measurement System
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "scalemass")
                            .foregroundColor(Color.brandPrimary)
                            .padding(8)
                            .background(Color.brandPrimary.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("Measurement System")
                            .font(.custom("PlusJakartaSans-Medium", size: 16))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 0) {
                        Button {
                            viewModel.measurementSystem = "Metric"
                        } label: {
                            Text("Metric")
                                .font(.custom("PlusJakartaSans-SemiBold", size: 12))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(viewModel.measurementSystem == "Metric" ? Color.brandPrimary : Color.clear)
                                .foregroundColor(viewModel.measurementSystem == "Metric" ? .white : .slate400)
                                .cornerRadius(6)
                                .shadow(color: viewModel.measurementSystem == "Metric" ? Color.black.opacity(0.05) : Color.clear, radius: 2, x: 0, y: 1)
                        }
                        
                        Button {
                            viewModel.measurementSystem = "Imperial"
                        } label: {
                            Text("Imperial")
                                .font(.custom("PlusJakartaSans-SemiBold", size: 12))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(viewModel.measurementSystem == "Imperial" ? Color.brandPrimary : Color.clear)
                                .foregroundColor(viewModel.measurementSystem == "Imperial" ? .white : .slate400)
                                .cornerRadius(6)
                                .shadow(color: viewModel.measurementSystem == "Imperial" ? Color.black.opacity(0.05) : Color.clear, radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding(4)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                }
                .padding(16)
                
                Divider().background(Color.white.opacity(0.05))
                
                // Recipe Language
                Button {
                    // Open language picker
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "globe")
                            .foregroundColor(Color.brandPrimary)
                            .padding(8)
                            .background(Color.brandPrimary.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("Recipe Language")
                            .font(.custom("PlusJakartaSans-Medium", size: 16))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(viewModel.recipeLanguage)
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundColor(.white)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary.opacity(0.5))
                    }
                    .padding(16)
                }
            }
            .background(Color.surfaceDark)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
        }
    }
    
    private var subscriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SUBSCRIPTION & SYSTEM")
                .font(.custom("PlusJakartaSans-Bold", size: 12))
                .foregroundColor(.slate400)
                .padding(.horizontal, 8)
            
            VStack(spacing: 0) {
                // Premium Status
                Button {
                    viewModel.manageSubscription()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow500)
                            .padding(8)
                            .background(Color.yellow500.opacity(0.1))
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Premium Status")
                                .font(.custom("PlusJakartaSans-Medium", size: 16))
                                .foregroundColor(.white)
                            
                            Text("Manage Subscription")
                                .font(.custom("PlusJakartaSans-Regular", size: 12))
                                .foregroundColor(.slate400)
                        }
                        
                        Spacer()
                        
                        Text("ACTIVE")
                            .font(.custom("PlusJakartaSans-Bold", size: 10))
                            .foregroundColor(Color.brandPrimary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.brandPrimary.opacity(0.2))
                            .cornerRadius(4)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary.opacity(0.5))
                    }
                    .padding(16)
                }
                
                Divider().background(Color.white.opacity(0.05))
                
                // Push Notifications
                HStack(spacing: 12) {
                    Image(systemName: "bell.fill")
                        .foregroundColor(Color.brandPrimary)
                        .padding(8)
                        .background(Color.brandPrimary.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("Push Notifications")
                        .font(.custom("PlusJakartaSans-Medium", size: 16))
                        .foregroundColor(.slate800)
                    
                    Spacer()
                    
                    Toggle("", isOn: $viewModel.pushNotificationsEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: Color.brandPrimary))
                        .labelsHidden()
                }
                .padding(16)
            }
            .background(Color.surfaceDark)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SUPPORT & INFO")
                .font(.custom("PlusJakartaSans-Bold", size: 12))
                .foregroundColor(.slate400)
                .padding(.horizontal, 8)
            
            VStack(spacing: 0) {
                // Rate App
                SettingsRowLink(icon: "star.fill", title: "Rate App", action: viewModel.rateApp)
                
                Divider().background(Color.white.opacity(0.05))
                
                // Contact Support
                SettingsRowLink(icon: "envelope.fill", title: "Contact Support", action: viewModel.contactSupport)
                
                Divider().background(Color.white.opacity(0.05))
                
                // Terms of Use
                SettingsRowLink(icon: "doc.text.fill", title: "Terms of Use", action: viewModel.openTerms)
                
                Divider().background(Color.white.opacity(0.05))
                
                // Privacy Policy
                SettingsRowLink(icon: "hand.raised.fill", title: "Privacy Policy", action: viewModel.openPrivacy)
            }
            .background(Color.surfaceDark)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
        }
    }
    
    private var footerSection: some View {
        VStack(spacing: 16) {
            Text("Version 1.2.0 (Build 452)")
                .font(.custom("PlusJakartaSans-Medium", size: 12))
                .foregroundColor(.slate400)
            
            Button {
                viewModel.deleteAccount()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                    Text("Delete Account")
                }
                .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                .foregroundColor(.red)
            }
        }
    }
}

struct SettingsRowLink: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.slate400)
                
                Text(title)
                    .font(.custom("PlusJakartaSans-Medium", size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.slate400)
            }
            .padding(16)
        }
    }
}

// Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
