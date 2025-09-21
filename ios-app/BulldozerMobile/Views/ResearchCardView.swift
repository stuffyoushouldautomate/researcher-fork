//
//  ResearchCardView.swift
//  BulldozerMobile
//
//  Created by Bulldozer Team on 2025.
//  Copyright © 2025 Bulldozer. All rights reserved.
//

import SwiftUI

struct ResearchCardView: View {
    let source: ResearchSource
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(source.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(isExpanded ? nil : 2)
                    
                    HStack(spacing: 8) {
                        sourceTypeBadge
                        
                        Text(formatDate(source.date))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                relevanceIndicator
            }
            
            // Content
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    if let url = source.url {
                        Button(action: {
                            if let url = URL(string: url) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "link")
                                Text("View Source")
                            }
                            .font(.caption)
                            .foregroundColor(.orange)
                        }
                    }
                    
                    Text("Relevance: \(Int(source.relevance * 100))%")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Expand/Collapse Button
            if source.title.count > 30 {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    Text(isExpanded ? "Show less" : "Show more")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var sourceTypeBadge: some View {
        Text(source.type.rawValue)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(typeColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(typeColor.opacity(0.2))
            )
    }
    
    private var relevanceIndicator: some View {
        VStack(spacing: 4) {
            Text("\(Int(source.relevance * 100))%")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(relevanceColor)
            
            Circle()
                .fill(relevanceColor)
                .frame(width: 8, height: 8)
        }
    }
    
    private var typeColor: Color {
        switch source.type {
        case .legal:
            return .blue
        case .news:
            return .green
        case .financial:
            return .purple
        case .interview:
            return .orange
        case .document:
            return .gray
        }
    }
    
    private var relevanceColor: Color {
        if source.relevance >= 0.8 {
            return .green
        } else if source.relevance >= 0.6 {
            return .yellow
        } else {
            return .red
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    VStack(spacing: 12) {
        ResearchCardView(source: ResearchSource(
            title: "NLRB Filing Documents - Union Election Petition",
            type: .legal,
            url: "https://example.com",
            date: Date(),
            relevance: 0.95
        ))
        
        ResearchCardView(source: ResearchSource(
            title: "Employee Interview Transcripts",
            type: .interview,
            url: nil,
            date: Date(),
            relevance: 0.78
        ))
    }
    .padding()
    .background(Color.black)
}
