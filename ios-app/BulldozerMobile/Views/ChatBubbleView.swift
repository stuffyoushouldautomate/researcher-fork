//
//  ChatBubbleView.swift
//  BulldozerMobile
//
//  Created by Bulldozer Team on 2025.
//  Copyright © 2025 Bulldozer. All rights reserved.
//

import SwiftUI

struct ChatBubbleView: View {
    let message: ChatMessage
    @State private var isExpanded = false
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                messageBubble
                
                Text(formatTime(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if message.role == .assistant {
                Spacer(minLength: 50)
            }
        }
    }
    
    private var messageBubble: some View {
        VStack(alignment: .leading, spacing: 8) {
            if message.role == .assistant {
                HStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.orange)
                        .font(.title3)
                    
                    Text("Bulldozer AI")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                }
            }
            
            Text(message.content)
                .font(.body)
                .foregroundColor(message.role == .user ? .black : .white)
                .lineLimit(isExpanded ? nil : 10)
                .onTapGesture {
                    if message.content.count > 200 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isExpanded.toggle()
                        }
                    }
                }
            
            if message.content.count > 200 {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    Text(isExpanded ? "Show less" : "Show more")
                        .font(.caption)
                        .foregroundColor(message.role == .user ? .blue : .orange)
                }
            }
            
            if let researchId = message.researchId {
                researchButton(researchId: researchId)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(message.role == .user ? Color.white : Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            message.role == .user ? Color.clear : Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                )
        )
    }
    
    private func researchButton(researchId: String) -> some View {
        Button(action: {
            // This would trigger showing the research view
            // For now, we'll just show an alert
        }) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.caption)
                
                Text("View Research")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(.orange)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    VStack(spacing: 16) {
        ChatBubbleView(message: ChatMessage(
            role: .user,
            content: "Can you research the labor conditions at TechCorp?",
            timestamp: Date(),
            researchId: nil
        ))
        
        ChatBubbleView(message: ChatMessage(
            role: .assistant,
            content: "I'll research TechCorp's labor conditions for you. This will include investigating their union activity, worker complaints, safety violations, and overall employee satisfaction. The research will cover recent news, legal filings, and worker testimonials.",
            timestamp: Date(),
            researchId: "research-123"
        ))
    }
    .padding()
    .background(Color.black)
}
