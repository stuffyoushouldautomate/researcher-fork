//
//  TaskDetailView.swift
//  BulldozerMobile
//
//  Created by Bulldozer AI Team
//  Copyright © 2025 Bulldozer™. All rights reserved.
//

import SwiftUI

struct TaskDetailView: View {
    let task: ResearchTask
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var agentManager: AgentManager
    @State private var showingEditSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            StatusBadge(status: task.status)
                            PriorityBadge(priority: task.priority)
                            Spacer()
                        }
                    }
                    
                    // Progress Section
                    if task.status == .inProgress || task.status == .paused {
                        ProgressSection(task: task)
                    }
                    
                    // Task Details
                    TaskDetailsSection(task: task)
                    
                    // Steps
                    if !task.steps.isEmpty {
                        StepsSection(steps: task.steps)
                    }
                    
                    // Resources
                    if !task.resources.isEmpty {
                        ResourcesSection(resources: task.resources)
                    }
                    
                    // Insights
                    if !task.insights.isEmpty {
                        TaskInsightsSection(insights: task.insights)
                    }
                    
                    // Actions
                    ActionsSection(task: task)
                }
                .padding()
            }
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditSheet = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            TaskEditView(task: task)
        }
    }
}

struct StatusBadge: View {
    let status: TaskStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .cornerRadius(8)
    }
}

struct ProgressSection: View {
    let task: ResearchTask
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progress")
                .font(.headline)
            
            VStack(spacing: 8) {
                HStack {
                    Text("\(Int(task.progress * 100))% Complete")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(formatDuration(task.estimatedDuration))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                ProgressView(value: task.progress)
                    .tint(.orange)
                
                if let currentStep = task.currentStep {
                    Text("Current Step: \(currentStep)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}

struct TaskDetailsSection: View {
    let task: ResearchTask
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Task Details")
                .font(.headline)
            
            VStack(spacing: 8) {
                DetailRow(label: "Description", value: task.description)
                DetailRow(label: "Created", value: task.createdAt.formatted(date: .abbreviated, time: .shortened))
                DetailRow(label: "Estimated Duration", value: formatDuration(task.estimatedDuration))
                DetailRow(label: "Priority", value: task.priority.rawValue)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}

struct StepsSection: View {
    let steps: [ResearchStep]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Research Steps")
                .font(.headline)
            
            ForEach(steps) { step in
                StepCard(step: step)
            }
        }
    }
}

struct StepCard: View {
    let step: ResearchStep
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: stepIcon)
                .foregroundColor(stepColor)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(step.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(step.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(step.status.rawValue.capitalized)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(stepColor)
                
                if let duration = step.actualDuration {
                    Text(formatDuration(duration))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private var stepIcon: String {
        switch step.status {
        case .pending: return "clock"
        case .inProgress: return "play.circle"
        case .completed: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        }
    }
    
    private var stepColor: Color {
        switch step.status {
        case .pending: return .gray
        case .inProgress: return .orange
        case .completed: return .green
        case .failed: return .red
        }
    }
}

struct ResourcesSection: View {
    let resources: [Resource]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Resources (\(resources.count))")
                .font(.headline)
            
            ForEach(resources) { resource in
                ResourceCard(resource: resource)
            }
        }
    }
}

struct ResourceCard: View {
    let resource: Resource
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: resourceIcon)
                .foregroundColor(.orange)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(resource.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(resource.url)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(resource.relevanceScore * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                
                Text(resource.type.rawValue.capitalized)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private var resourceIcon: String {
        switch resource.type {
        case .article: return "doc.text.fill"
        case .paper: return "doc.plaintext.fill"
        case .video: return "play.rectangle.fill"
        case .podcast: return "waveform"
        case .data: return "chart.bar.fill"
        case .tool: return "wrench.fill"
        }
    }
}

struct TaskInsightsSection: View {
    let insights: [Insight]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Insights (\(insights.count))")
                .font(.headline)
            
            ForEach(insights) { insight in
                TaskInsightCard(insight: insight)
            }
        }
    }
}

struct TaskInsightCard: View {
    let insight: Insight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(insight.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(Int(insight.confidence * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            
            Text(insight.content)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct ActionsSection: View {
    let task: ResearchTask
    @EnvironmentObject var agentManager: AgentManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Actions")
                .font(.headline)
            
            VStack(spacing: 8) {
                if task.status == .inProgress {
                    ActionButton(
                        title: "Pause Task",
                        icon: "pause.circle.fill",
                        color: .yellow
                    ) {
                        agentManager.pauseCurrentTask()
                    }
                }
                
                if task.status == .paused {
                    ActionButton(
                        title: "Resume Task",
                        icon: "play.circle.fill",
                        color: .green
                    ) {
                        agentManager.resumeCurrentTask()
                    }
                }
                
                if task.status == .inProgress || task.status == .paused {
                    ActionButton(
                        title: "Stop Task",
                        icon: "stop.circle.fill",
                        color: .red
                    ) {
                        agentManager.stopCurrentTask()
                    }
                }
                
                if task.status == .completed {
                    ActionButton(
                        title: "View Report",
                        icon: "doc.text.fill",
                        color: .blue
                    ) {
                        // Navigate to report
                    }
                }
            }
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TaskEditView: View {
    let task: ResearchTask
    @Environment(\.dismiss) private var dismiss
    @State private var editedTitle: String
    @State private var editedDescription: String
    @State private var editedPriority: TaskPriority
    
    init(task: ResearchTask) {
        self.task = task
        self._editedTitle = State(initialValue: task.title)
        self._editedDescription = State(initialValue: task.description)
        self._editedPriority = State(initialValue: task.priority)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Task Details") {
                    TextField("Title", text: $editedTitle)
                    TextField("Description", text: $editedDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Priority") {
                    Picker("Priority", selection: $editedPriority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save changes
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TaskDetailView(task: ResearchTask(title: "Sample Task", description: "This is a sample research task"))
        .environmentObject(AgentManager())
}
