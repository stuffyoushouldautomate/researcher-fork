//
//  TaskSubmissionView.swift
//  BulldozerMobile
//
//  Created by Bulldozer AI Team
//  Copyright © 2025 Bulldozer™. All rights reserved.
//

import SwiftUI

struct TaskSubmissionView: View {
    @EnvironmentObject var agentManager: AgentManager
    @State private var taskTitle = ""
    @State private var taskDescription = ""
    @State private var selectedPriority: TaskPriority = .medium
    @State private var showingEstimate = false
    @State private var estimatedDuration: TimeInterval = 0
    @State private var isSubmitting = false
    @State private var showingConfirmation = false
    @State private var submittedTask: ResearchTask?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("New Research Task")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Submit a research task for your Bulldozer AI agent to analyze")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Task Form
                    VStack(spacing: 20) {
                        // Title Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Task Title")
                                .font(.headline)
                            
                            TextField("Enter a descriptive title for your research task", text: $taskTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Description Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            
                            TextField("Provide detailed description of what you want researched", text: $taskDescription, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(5...10)
                        }
                        
                        // Priority Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Priority Level")
                                .font(.headline)
                            
                            Picker("Priority", selection: $selectedPriority) {
                                ForEach(TaskPriority.allCases, id: \.self) { priority in
                                    HStack {
                                        Circle()
                                            .fill(priority.color)
                                            .frame(width: 12, height: 12)
                                        Text(priority.rawValue)
                                    }
                                    .tag(priority)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        // Estimate Button
                        Button(action: {
                            getEstimate()
                        }) {
                            HStack {
                                Image(systemName: "clock.fill")
                                Text("Get Time Estimate")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(taskTitle.isEmpty || taskDescription.isEmpty || isSubmitting)
                        
                        // Show Estimate if Available
                        if showingEstimate {
                            EstimateCard(duration: estimatedDuration, priority: selectedPriority)
                        }
                        
                        // Submit Button
                        Button(action: {
                            submitTask()
                        }) {
                            HStack {
                                if isSubmitting {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "paperplane.fill")
                                }
                                Text(isSubmitting ? "Submitting..." : "Submit Task")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canSubmit ? Color.orange : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(!canSubmit || isSubmitting)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Recent Tasks Preview
                    if !agentManager.recentTasks.isEmpty {
                        RecentTasksPreview()
                    }
                }
                .padding()
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingConfirmation) {
            if let task = submittedTask {
                TaskConfirmationView(task: task)
            }
        }
    }
    
    private var canSubmit: Bool {
        !taskTitle.isEmpty && !taskDescription.isEmpty && showingEstimate
    }
    
    private func getEstimate() {
        isSubmitting = true
        
        // Simulate API call to get estimate
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Mock estimation logic based on description length and priority
            let baseTime: TimeInterval = 1800 // 30 minutes base
            let complexityMultiplier = Double(taskDescription.count) / 500.0
            let priorityMultiplier: Double = {
                switch selectedPriority {
                case .low: return 0.7
                case .medium: return 1.0
                case .high: return 1.3
                case .urgent: return 1.5
                }
            }()
            
            estimatedDuration = baseTime * complexityMultiplier * priorityMultiplier
            showingEstimate = true
            isSubmitting = false
        }
    }
    
    private func submitTask() {
        isSubmitting = true
        
        let newTask = ResearchTask(
            title: taskTitle,
            description: taskDescription,
            priority: selectedPriority
        )
        
        // Simulate API submission
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            agentManager.submitTask(newTask)
            submittedTask = newTask
            showingConfirmation = true
            isSubmitting = false
            
            // Reset form
            taskTitle = ""
            taskDescription = ""
            selectedPriority = .medium
            showingEstimate = false
            estimatedDuration = 0
        }
    }
}

struct EstimateCard: View {
    let duration: TimeInterval
    let priority: TaskPriority
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.orange)
                Text("Estimated Duration")
                    .font(.headline)
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(formatDuration(duration))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("Based on task complexity and priority")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Priority")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Circle()
                            .fill(priority.color)
                            .frame(width: 8, height: 8)
                        Text(priority.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
            }
            
            // Breakdown
            VStack(alignment: .leading, spacing: 4) {
                Text("Estimated Breakdown:")
                    .font(.caption)
                    .fontWeight(.medium)
                
                EstimateBreakdownRow(phase: "Research & Data Collection", duration: duration * 0.4)
                EstimateBreakdownRow(phase: "Analysis & Processing", duration: duration * 0.3)
                EstimateBreakdownRow(phase: "Report Generation", duration: duration * 0.3)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
}

struct EstimateBreakdownRow: View {
    let phase: String
    let duration: TimeInterval
    
    var body: some View {
        HStack {
            Text(phase)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(formatDuration(duration))
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

struct RecentTasksPreview: View {
    @EnvironmentObject var agentManager: AgentManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Tasks")
                .font(.headline)
            
            ForEach(agentManager.recentTasks.prefix(3)) { task in
                RecentTaskRow(task: task)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct RecentTaskRow: View {
    let task: ResearchTask
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(task.status.rawValue)
                    .font(.caption)
                    .foregroundColor(task.status.color)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatDuration(task.estimatedDuration))
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(task.createdAt, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct TaskConfirmationView: View {
    let task: ResearchTask
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var agentManager: AgentManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Success Animation
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: true)
                    
                    Text("Task Submitted Successfully!")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                // Task Summary
                VStack(alignment: .leading, spacing: 12) {
                    Text("Task Summary")
                        .font(.headline)
                    
                    TaskSummaryRow(label: "Title", value: task.title)
                    TaskSummaryRow(label: "Priority", value: task.priority.rawValue)
                    TaskSummaryRow(label: "Status", value: task.status.rawValue)
                    TaskSummaryRow(label: "Estimated Duration", value: formatDuration(task.estimatedDuration))
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Next Steps
                VStack(alignment: .leading, spacing: 12) {
                    Text("What's Next?")
                        .font(.headline)
                    
                    NextStepRow(
                        icon: "clock.fill",
                        title: "Review & Approval",
                        description: "Your task will be reviewed and approved before execution"
                    )
                    
                    NextStepRow(
                        icon: "play.fill",
                        title: "Agent Execution",
                        description: "The Bulldozer AI will begin research and analysis"
                    )
                    
                    NextStepRow(
                        icon: "bell.fill",
                        title: "Progress Updates",
                        description: "You'll receive real-time updates on the dashboard"
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .navigationTitle("Task Confirmed")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct TaskSummaryRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

struct NextStepRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    TaskSubmissionView()
        .environmentObject(AgentManager())
}
