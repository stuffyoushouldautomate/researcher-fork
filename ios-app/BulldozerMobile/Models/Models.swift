//
//  Models.swift
//  BulldozerMobile
//
//  Created by Bulldozer Team on 2025.
//  Copyright © 2025 Bulldozer. All rights reserved.
//

import Foundation

// MARK: - Chat Models
struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let role: MessageRole
    let content: String
    let timestamp: Date
    let researchId: String?
    
    enum MessageRole: String, Codable {
        case user = "user"
        case assistant = "assistant"
    }
}

// MARK: - Research Models
struct ResearchReport: Identifiable, Codable {
    let id: String
    let title: String
    let company: String
    let summary: String
    let keyFindings: [String]
    let sources: [ResearchSource]
    let analysis: RiskAnalysis
    let createdAt: Date
    let updatedAt: Date
}

struct ResearchSource: Identifiable, Codable {
    let id = UUID()
    let title: String
    let type: SourceType
    let url: String?
    let date: Date
    let relevance: Double
    
    enum SourceType: String, Codable {
        case legal = "Legal"
        case news = "News"
        case financial = "Financial"
        case interview = "Interview"
        case document = "Document"
    }
}

struct RiskAnalysis: Codable {
    let level: RiskLevel
    let score: Int
    let recommendations: [String]
    let concerns: [String]
    
    enum RiskLevel: String, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case critical = "Critical"
    }
}

// MARK: - API Models
struct ChatRequest: Codable {
    let message: String
    let enableDeepThinking: Bool
    let enableBackgroundInvestigation: Bool
    let reportStyle: String
}

struct ChatResponse: Codable {
    let message: String
    let researchId: String?
    let isComplete: Bool
}

struct ResearchRequest: Codable {
    let query: String
    let company: String?
    let focusAreas: [String]
}

// MARK: - App State Models
class AppState: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var currentResearch: ResearchReport?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func addMessage(_ message: ChatMessage) {
        messages.append(message)
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func setCurrentResearch(_ research: ResearchReport?) {
        currentResearch = research
    }
}
