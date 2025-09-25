//
//  DashboardView.swift
//  BulldozerMobile
//
//  Created by Bulldozer AI Team
//  Copyright © 2025 Bulldozer™. All rights reserved.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var agentManager: AgentManager
    @EnvironmentObject var reportManager: ReportManager
    @EnvironmentObject var insightsManager: InsightsManager
    @State private var showingTaskDetails = false
    @State private var selectedTask: ResearchTask?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with Agent Status
                    AgentStatusCard()
                    
                    // Current Task Progress
                    if let currentTask = agentManager.currentTask {
                        CurrentTaskCard(task: currentTask) {
                            selectedTask = currentTask
                            showingTaskDetails = true
                        }
                    }
                    
                    // Performance Metrics
                    PerformanceMetricsCard()
                    
                    // Recent Insights
                    RecentInsightsCard()
                    
                    // Quick Actions
                    QuickActionsCard()
                }
                .padding()
            }
            .navigationTitle("Bulldozer™ Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await agentManager.refreshStatus()
            }
        }
        .sheet(isPresented: $showingTaskDetails) {
            if let task = selectedTask {
                TaskDetailView(task: task)
            }
        }
    }
}

struct AgentStatusCard: View {
    @EnvironmentObject var agentManager: AgentManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: agentManager.isOnline ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(agentManager.isOnline ? .green : .red)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text("Agent Status")
                        .font(.headline)
                    Text(agentManager.isOnline ? "Online & Active" : "Offline")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if agentManager.isOnline {
                    PulsingDot()
                }
            }
            
            if agentManager.isOnline {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Active Connections")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(agentManager.activeConnections.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Last Activity")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(agentManager.lastActivity, style: .relative)
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct CurrentTaskCard: View {
    let task: ResearchTask
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Current Task")
                    .font(.headline)
                Spacer()
                Text(task.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(task.status.color.opacity(0.2))
                    .foregroundColor(task.status.color)
                    .cornerRadius(8)
            }
            
            Text(task.title)
                .font(.title3)
                .fontWeight(.semibold)
            
            if let currentStep = task.currentStep {
                Text("Current Step: \(currentStep)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: task.progress)
                .tint(.orange)
            
            HStack {
                Text("\(Int(task.progress * 100))% Complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Est. \(formatDuration(task.estimatedDuration))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onTapGesture {
            onTap()
        }
    }
}

struct PerformanceMetricsCard: View {
    @EnvironmentObject var agentManager: AgentManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Performance Metrics")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                MetricTile(
                    title: "Tasks Completed",
                    value: "\(agentManager.metrics.tasksCompleted)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                MetricTile(
                    title: "Success Rate",
                    value: "\(Int(agentManager.metrics.successRate * 100))%",
                    icon: "target",
                    color: .blue
                )
                
                MetricTile(
                    title: "Insights Generated",
                    value: "\(agentManager.metrics.insightsGenerated)",
                    icon: "lightbulb.fill",
                    color: .orange
                )
                
                MetricTile(
                    title: "Avg Duration",
                    value: formatDuration(agentManager.metrics.averageTaskDuration),
                    icon: "clock.fill",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct MetricTile: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct RecentInsightsCard: View {
    @EnvironmentObject var insightsManager: InsightsManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Insights")
                .font(.headline)
            
            if insightsManager.recentInsights.isEmpty {
                Text("No recent insights")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(insightsManager.recentInsights.prefix(3)) { insight in
                    InsightRow(insight: insight)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct InsightRow: View {
    let insight: Insight
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.orange)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(insight.content)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(Int(insight.confidence * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                
                Text(insight.discoveredAt, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct QuickActionsCard: View {
    @EnvironmentObject var agentManager: AgentManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
            
            HStack(spacing: 12) {
                QuickActionButton(
                    title: "Pause Task",
                    icon: "pause.circle.fill",
                    color: .yellow
                ) {
                    agentManager.pauseCurrentTask()
                }
                .disabled(agentManager.currentTask?.status != .inProgress)
                
                QuickActionButton(
                    title: "Resume Task",
                    icon: "play.circle.fill",
                    color: .green
                ) {
                    agentManager.resumeCurrentTask()
                }
                .disabled(agentManager.currentTask?.status != .paused)
                
                QuickActionButton(
                    title: "Stop Task",
                    icon: "stop.circle.fill",
                    color: .red
                ) {
                    agentManager.stopCurrentTask()
                }
                .disabled(agentManager.currentTask?.status != .inProgress)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PulsingDot: View {
    @State private var isPulsing = false
    
    var body: some View {
        Circle()
            .fill(Color.green)
            .frame(width: 8, height: 8)
            .scaleEffect(isPulsing ? 1.2 : 1.0)
            .opacity(isPulsing ? 0.5 : 1.0)
            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)
            .onAppear {
                isPulsing = true
            }
    }
}

// Helper function
func formatDuration(_ duration: TimeInterval) -> String {
    let hours = Int(duration) / 3600
    let minutes = Int(duration) % 3600 / 60
    
    if hours > 0 {
        return "\(hours)h \(minutes)m"
    } else {
        return "\(minutes)m"
    }
}

#Preview {
    DashboardView()
        .environmentObject(AgentManager())
        .environmentObject(ReportManager())
        .environmentObject(InsightsManager())
}
