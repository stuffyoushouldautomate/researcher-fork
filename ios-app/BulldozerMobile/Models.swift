//
//  Models.swift
//  BulldozerMobile
//
//  Created by Bulldozer AI Team
//  Copyright © 2025 Bulldozer™. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Research Task Models
struct ResearchTask: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let priority: TaskPriority
    var estimatedDuration: TimeInterval
    let createdAt: Date
    var status: TaskStatus
    var progress: Double
    var currentStep: String?
    var steps: [ResearchStep]
    var resources: [Resource]
    var insights: [Insight]
    
    init(title: String, description: String, priority: TaskPriority = .medium) {
        self.title = title
        self.description = description
        self.priority = priority
        self.estimatedDuration = 0
        self.createdAt = Date()
        self.status = .pending
        self.progress = 0.0
        self.steps = []
        self.resources = []
        self.insights = []
    }
}

enum TaskPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .blue
        case .high: return .orange
        case .urgent: return .red
        }
    }
}

enum TaskStatus: String, CaseIterable, Codable {
    case pending = "Pending"
    case approved = "Approved"
    case inProgress = "In Progress"
    case paused = "Paused"
    case completed = "Completed"
    case cancelled = "Cancelled"
    
    var color: Color {
        switch self {
        case .pending: return .gray
        case .approved: return .blue
        case .inProgress: return .orange
        case .paused: return .yellow
        case .completed: return .green
        case .cancelled: return .red
        }
    }
}

struct ResearchStep: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    var status: StepStatus
    let estimatedDuration: TimeInterval
    var actualDuration: TimeInterval?
    var resources: [Resource]
    var insights: [Insight]
    
    enum StepStatus: String, Codable {
        case pending, inProgress, completed, failed
    }
}

struct Resource: Identifiable, Codable {
    let id = UUID()
    let title: String
    let url: String
    let type: ResourceType
    let relevanceScore: Double
    let extractedAt: Date
    
    enum ResourceType: String, Codable {
        case article, paper, video, podcast, data, tool
    }
}

struct Insight: Identifiable, Codable {
    let id = UUID()
    let title: String
    let content: String
    let confidence: Double
    let category: InsightCategory
    let discoveredAt: Date
    let sources: [String]
    
    enum InsightCategory: String, Codable, CaseIterable {
        case trend, pattern, correlation, prediction, recommendation
    }
}

// MARK: - Agent Status Models
struct AgentStatus: Codable {
    let isOnline: Bool
    let currentTask: ResearchTask?
    let activeConnections: [String]
    let performanceMetrics: PerformanceMetrics
    let lastActivity: Date
}

struct PerformanceMetrics: Codable {
    var tasksCompleted: Int
    var averageTaskDuration: TimeInterval
    var successRate: Double
    var insightsGenerated: Int
    var resourcesProcessed: Int
}

// MARK: - Report Models
struct ResearchReport: Identifiable, Codable {
    let id = UUID()
    let taskId: UUID
    let title: String
    let executiveSummary: String
    let keyFindings: [KeyFinding]
    let dataVisualizations: [DataVisualization]
    let recommendations: [Recommendation]
    let methodology: String
    let sources: [Resource]
    let generatedAt: Date
    let confidence: Double
}

struct KeyFinding: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let impact: ImpactLevel
    let evidence: [String]
    
    enum ImpactLevel: String, Codable {
        case low, medium, high, critical
    }
}

struct DataVisualization: Identifiable, Codable {
    let id = UUID()
    let title: String
    let type: VisualizationType
    let data: [DataPoint]
    
    enum VisualizationType: String, Codable {
        case bar, line, pie, scatter, heatmap
    }
}

struct DataPoint: Codable {
    let label: String
    let value: Double
    let color: String?
}

struct Recommendation: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let priority: TaskPriority
    let implementationSteps: [String]
    let expectedOutcome: String
}
