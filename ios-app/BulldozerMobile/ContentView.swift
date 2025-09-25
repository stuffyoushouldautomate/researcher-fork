//
//  ContentView.swift
//  BulldozerMobile
//
//  Created by Bulldozer AI Team
//  Copyright © 2025 Bulldozer™. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var agentManager: AgentManager
    @EnvironmentObject var reportManager: ReportManager
    @EnvironmentObject var insightsManager: InsightsManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Dashboard")
                }
                .tag(0)
            
            TaskSubmissionView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("New Task")
                }
                .tag(1)
            
            ReportsView()
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Reports")
                }
                .tag(2)
            
            InsightsView()
                .tabItem {
                    Image(systemName: "lightbulb.fill")
                    Text("Insights")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(.orange)
        .onAppear {
            agentManager.startMonitoring()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AgentManager())
        .environmentObject(ReportManager())
        .environmentObject(InsightsManager())
}
