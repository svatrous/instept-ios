//
//  ImportRecipeSheet.swift
//  Instept
//
//  Created by AI on 2026-02-13.
//

import SwiftUI

struct ImportRecipeSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var recipeURL: String = ""
    @State private var isImporting: Bool = false
    @State private var showProcessingView: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    // Callback to pass the imported recipe back to the parent view
    var onImport: (Recipe) -> Void
    
    private let backendUrl = "https://web-production-11711.up.railway.app"
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Import from Link")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.05))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 32)
            
            // URL Input Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Recipe URL")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
                
                // URL Input Field with Gradient Border
                ZStack {
                    // Gradient glow
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [Color("primary"), Color.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                        .blur(radius: 4)
                        .opacity(0.3)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "link")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                        
                        TextField("", text: $recipeURL, prompt: Text("https://...").foregroundColor(.gray.opacity(0.6)))
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .autocapitalization(.none)
                            .keyboardType(.URL)
                            .disableAutocorrection(true)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                // Paste Button
                Button(action: {
                    pasteFromClipboard()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.on.clipboard")
                            .foregroundColor(Color("primary"))
                        Text("Paste from Clipboard")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 24)
            
            // Platform Shortcuts
            HStack(spacing: 24) {
                PlatformButton(icon: "music.note", label: "TIKTOK")
                PlatformButton(icon: "camera", label: "REELS")
                PlatformButton(icon: "play.circle", label: "YOUTUBE")
            }
            .padding(.vertical, 32)
            
            // Import Button
            Button(action: {
                importRecipe()
            }) {
                HStack(spacing: 8) {
                    if isImporting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Import Recipe")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [Color("primary"), Color.orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color("primary").opacity(0.3), radius: 10, x: 0, y: 4)
            }
            .disabled(recipeURL.isEmpty || isImporting)
            .opacity(recipeURL.isEmpty ? 0.5 : 1.0)
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color("background-dark"))
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .alert("Import Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .fullScreenCover(isPresented: $showProcessingView) {
            ProcessingView(onGotIt: {
                showProcessingView = false
                dismiss() // Close the sheet entirely
            })
        }
    }
    
    private func pasteFromClipboard() {
        if let clipboardString = UIPasteboard.general.string {
            recipeURL = clipboardString
        }
    }
    
    private func importRecipe() {
        guard !recipeURL.isEmpty else { return }
        
        isImporting = true
        
        guard let url = URL(string: "\(backendUrl)/analyze") else {
            showError(message: "Invalid backend URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
        print("Sending import request with FCM Token: \(fcmToken ?? "None")")
        
        var body: [String: String] = ["url": recipeURL]
        if let token = fcmToken {
            body["fcm_token"] = token
        }
        
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isImporting = false
                
                if let error = error {
                    showError(message: "Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    showError(message: "No data received")
                    return
                }
                
                // Debug: Print JSON
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON: \(jsonString)")
                }
                
                // Attempt to decode ProcessingResponse first (NEW FLOW)
                struct ProcessingResponse: Decodable {
                    let status: String
                    let message: String
                }
                
                do {
                    let decoder = JSONDecoder()
                    let processingResponse = try decoder.decode(ProcessingResponse.self, from: data)
                    
                    if processingResponse.status == "processing" {
                        // Show the processing view
                        showProcessingView = true
                    } else {
                        // Fallback or legacy handling?
                        showError(message: "Unexpected status: \(processingResponse.status)")
                    }
                    
                } catch {
                    // Fallback to Recipe decoding check (just in case backend rolled back or something)
                    // But actually we changed backend, so this will fail.
                    // Just report error.
                    print("Decoding error: \(error)")
                    showError(message: "Failed to parse response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
}

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

#Preview {
    Text("Home View")
        .sheet(isPresented: .constant(true)) {
            ImportRecipeSheet(onImport: { _ in })
        }
}
