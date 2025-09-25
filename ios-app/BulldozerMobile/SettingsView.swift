//
//  SettingsView.swift
//  BulldozerMobile
//
//  Created by Bulldozer AI Team
//  Copyright © 2025 Bulldozer™. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var agentManager: AgentManager
    @State private var apiUrl = "https://bulldozerai.up.railway.app/api"
    @State private var notificationsEnabled = true
    @State private var autoRefresh = true
    @State private var refreshInterval = 5.0
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            List {
                // Connection Settings
                Section("Connection") {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.orange)
                        VStack(alignment: .leading) {
                            Text("API Endpoint")
                            Text(apiUrl)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button("Edit") {
                            // Edit API URL
                        }
                        .font(.caption)
                    }
                    
                    HStack {
                        Image(systemName: agentManager.isOnline ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(agentManager.isOnline ? .green : .red)
                        Text("Connection Status")
                        Spacer()
                        Text(agentManager.isOnline ? "Connected" : "Disconnected")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Notification Settings
                Section("Notifications") {
                    Toggle(isOn: $notificationsEnabled) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                            Text("Enable Notifications")
                        }
                    }
                    
                    if notificationsEnabled {
                        NavigationLink("Notification Settings") {
                            NotificationSettingsView()
                        }
                    }
                }
                
                // App Settings
                Section("App Settings") {
                    Toggle(isOn: $autoRefresh) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.orange)
                            Text("Auto Refresh")
                        }
                    }
                    
                    if autoRefresh {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "timer")
                                    .foregroundColor(.orange)
                                Text("Refresh Interval")
                                Spacer()
                                Text("\(Int(refreshInterval))s")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Slider(value: $refreshInterval, in: 1...30, step: 1)
                                .accentColor(.orange)
                        }
                    }
                }
                
                // Data & Privacy
                Section("Data & Privacy") {
                    NavigationLink("Data Usage") {
                        DataUsageView()
                    }
                    
                    NavigationLink("Privacy Policy") {
                        PrivacyPolicyView()
                    }
                    
                    Button("Clear Cache") {
                        // Clear cache
                    }
                    .foregroundColor(.red)
                }
                
                // About
                Section("About") {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.orange)
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button("About Bulldozer™") {
                        showingAbout = true
                    }
                    
                    Button("Contact Support") {
                        // Contact support
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
}

struct NotificationSettingsView: View {
    @State private var taskUpdates = true
    @State private var reportReady = true
    @State private var insightsDiscovered = true
    @State private var agentStatus = false
    
    var body: some View {
        List {
            Section("Notification Types") {
                Toggle("Task Updates", isOn: $taskUpdates)
                Toggle("Report Ready", isOn: $reportReady)
                Toggle("New Insights", isOn: $insightsDiscovered)
                Toggle("Agent Status Changes", isOn: $agentStatus)
            }
            
            Section("Delivery") {
                HStack {
                    Text("Quiet Hours")
                    Spacer()
                    Text("10 PM - 8 AM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DataUsageView: View {
    var body: some View {
        List {
            Section("Data Usage") {
                DataUsageRow(title: "Tasks Processed", value: "47")
                DataUsageRow(title: "Reports Generated", value: "23")
                DataUsageRow(title: "Insights Discovered", value: "156")
                DataUsageRow(title: "Resources Analyzed", value: "892")
            }
            
            Section("Storage") {
                DataUsageRow(title: "Cache Size", value: "12.5 MB")
                DataUsageRow(title: "Reports Storage", value: "45.2 MB")
                DataUsageRow(title: "Total Storage", value: "57.7 MB")
            }
        }
        .navigationTitle("Data Usage")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DataUsageRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Last updated: January 2025")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Data Collection")
                        .font(.headline)
                    
                    Text("Bulldozer Mobile collects minimal data necessary for functionality. We store your research tasks, generated reports, and insights locally on your device.")
                        .font(.body)
                    
                    Text("Data Usage")
                        .font(.headline)
                    
                    Text("Your data is used solely to provide AI research services. We do not share your research data with third parties without your explicit consent.")
                        .font(.body)
                    
                    Text("Data Security")
                        .font(.headline)
                    
                    Text("All data transmission is encrypted using industry-standard protocols. Your research data remains secure and private.")
                        .font(.body)
                }
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Logo and Branding
                VStack(spacing: 16) {
                    Image(systemName: "hammer.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    Text("Bulldozer™")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("AI Research Assistant")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                // Description
                VStack(alignment: .leading, spacing: 16) {
                    Text("About Bulldozer™")
                        .font(.headline)
                    
                    Text("Bulldozer is an advanced AI research assistant that automates complex research tasks, generates comprehensive reports, and discovers actionable insights. Built with cutting-edge AI technology, Bulldozer helps you bulldoze through information overload and get to the insights that matter.")
                        .font(.body)
                        .lineSpacing(4)
                    
                    Text("Features")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        FeatureRow(icon: "brain.head.profile", title: "Intelligent Research", description: "AI-powered research and analysis")
                        FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Real-time Monitoring", description: "Track progress and insights in real-time")
                        FeatureRow(icon: "doc.text.fill", title: "Comprehensive Reports", description: "Detailed reports with visualizations")
                        FeatureRow(icon: "lightbulb.fill", title: "Insight Discovery", description: "Automated insight generation")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Version Info
                VStack(spacing: 8) {
                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("Built with SwiftUI and powered by AI")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Close") {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
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
    SettingsView()
        .environmentObject(AgentManager())
}
