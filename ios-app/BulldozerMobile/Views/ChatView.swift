//
//  ChatView.swift
//  BulldozerMobile
//
//  Created by Bulldozer Team on 2025.
//  Copyright © 2025 Bulldozer. All rights reserved.
//

import SwiftUI

struct ChatView: View {
    @Binding var showingResearch: Bool
    @StateObject private var appState = AppState()
    @StateObject private var apiService = APIService.shared
    @State private var messageText = ""
    @State private var isTyping = false
    @State private var showingSettings = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Messages
            messagesView
            
            // Input
            inputView
        }
        .background(Color.clear)
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("🚜 Bulldozer")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Labor Union Research")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: { showingSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.white)
                    .font(.title3)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 15)
    }
    
    private var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    if appState.messages.isEmpty {
                        welcomeView
                    } else {
                        ForEach(appState.messages) { message in
                            ChatBubbleView(message: message)
                                .id(message.id)
                        }
                    }
                    
                    if isTyping {
                        typingIndicator
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .onChange(of: appState.messages.count) { _ in
                if let lastMessage = appState.messages.last {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    private var welcomeView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("Welcome to Bulldozer")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("Your powerful labor union research assistant")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                quickActionButton(
                    title: "Research Company",
                    subtitle: "Investigate labor conditions",
                    icon: "building.2.fill"
                ) {
                    sendMessage("Research the labor conditions and union activity at a major tech company")
                }
                
                quickActionButton(
                    title: "Find Violations",
                    subtitle: "Search for labor violations",
                    icon: "exclamationmark.triangle.fill"
                ) {
                    sendMessage("Find recent labor violations and safety issues in the manufacturing industry")
                }
                
                quickActionButton(
                    title: "Union Resources",
                    subtitle: "Get organizing tools",
                    icon: "person.3.fill"
                ) {
                    sendMessage("What resources are available for workers looking to organize a union?")
                }
            }
        }
        .padding(.top, 40)
    }
    
    private func quickActionButton(
        title: String,
        subtitle: String,
        icon: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.orange)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var typingIndicator: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .foregroundColor(.orange)
                .font(.title3)
            
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 6, height: 6)
                        .scaleEffect(isTyping ? 1.0 : 0.5)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: isTyping
                        )
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
            )
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private var inputView: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.white.opacity(0.1))
            
            HStack(spacing: 12) {
                TextField("Ask about labor conditions, unions, violations...", text: $messageText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                    .foregroundColor(.white)
                    .onSubmit {
                        sendMessage(messageText)
                    }
                
                Button(action: { sendMessage(messageText) }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundColor(messageText.isEmpty ? .gray : .orange)
                }
                .disabled(messageText.isEmpty || isTyping)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
        }
        .background(Color.clear)
    }
    
    private func sendMessage(_ text: String) {
        guard !text.isEmpty else { return }
        
        let userMessage = ChatMessage(
            role: .user,
            content: text,
            timestamp: Date(),
            researchId: nil
        )
        
        appState.addMessage(userMessage)
        messageText = ""
        isTyping = true
        
        Task {
            do {
                let response = try await apiService.sendMessage(
                    text,
                    enableDeepThinking: true,
                    enableBackgroundInvestigation: true
                )
                
                let assistantMessage = ChatMessage(
                    role: .assistant,
                    content: response.message,
                    timestamp: Date(),
                    researchId: response.researchId
                )
                
                await MainActor.run {
                    appState.addMessage(assistantMessage)
                    isTyping = false
                    
                    if let researchId = response.researchId {
                        // Show research view after a brief delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            showingResearch = true
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    isTyping = false
                    appState.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Settings coming soon...")
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
    }
}

#Preview {
    ChatView(showingResearch: .constant(false))
}
