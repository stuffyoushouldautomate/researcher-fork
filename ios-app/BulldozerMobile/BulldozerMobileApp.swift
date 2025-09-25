//
//  BulldozerMobileApp.swift
//  BulldozerMobile
//
//  Created by Bulldozer AI Team
//  Copyright © 2025 Bulldozer™. All rights reserved.
//

import SwiftUI

@main
struct BulldozerMobileApp: App {
    @StateObject private var agentManager = AgentManager()
    @StateObject private var reportManager = ReportManager()
    @StateObject private var insightsManager = InsightsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(agentManager)
                .environmentObject(reportManager)
                .environmentObject(insightsManager)
                .preferredColorScheme(.dark)
        }
    }
}
