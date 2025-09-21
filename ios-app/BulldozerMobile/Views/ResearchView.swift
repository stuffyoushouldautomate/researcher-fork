//
//  ResearchView.swift
//  BulldozerMobile
//
//  Created by Bulldozer Team on 2025.
//  Copyright © 2025 Bulldozer. All rights reserved.
//

import SwiftUI

struct ResearchView: View {
    @Binding var isPresented: Bool
    @StateObject private var apiService = APIService.shared
    @State private var selectedTab = 0
    @State private var researchReport: ResearchReport?
    @State private var isLoading = true
    
    private let tabs = ["Overview", "Sources", "Analysis"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Tab Bar
            tabBarView
            
            // Content
            contentView
        }
        .background(Color.clear)
        .onAppear {
            loadResearchData()
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { isPresented = false }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Research Report")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Labor Union Investigation")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: shareReport) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                Button(action: exportReport) {
                    Image(systemName: "doc.badge.arrow.down")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 15)
    }
    
    private var tabBarView: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: { selectedTab = index }) {
                    VStack(spacing: 8) {
                        Text(tab)
                            .font(.subheadline)
                            .fontWeight(selectedTab == index ? .semibold : .regular)
                            .foregroundColor(selectedTab == index ? .orange : .gray)
                        
                        Rectangle()
                            .fill(selectedTab == index ? Color.orange : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 15)
    }
    
    private var contentView: some View {
        ScrollView {
            if isLoading {
                loadingView
            } else if let report = researchReport {
                switch selectedTab {
                case 0:
                    overviewTab(report: report)
                case 1:
                    sourcesTab(report: report)
                case 2:
                    analysisTab(report: report)
                default:
                    EmptyView()
                }
            } else {
                errorView
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.orange)
            
            Text("Analyzing research data...")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Failed to load research")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Please try again later")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button("Retry") {
                loadResearchData()
            }
            .foregroundColor(.orange)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.orange.opacity(0.1))
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private func overviewTab(report: ResearchReport) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // Company Header
            VStack(alignment: .leading, spacing: 8) {
                Text(report.company)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(report.title)
                    .font(.headline)
                    .foregroundColor(.orange)
            }
            
            // Summary
            VStack(alignment: .leading, spacing: 12) {
                Text("Summary")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(report.summary)
                    .font(.body)
                    .foregroundColor(.gray)
                    .lineSpacing(4)
            }
            
            // Key Findings
            VStack(alignment: .leading, spacing: 12) {
                Text("Key Findings")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(report.keyFindings.enumerated()), id: \.offset) { index, finding in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                                .frame(width: 20, height: 20)
                                .background(
                                    Circle()
                                        .fill(Color.orange.opacity(0.2))
                                )
                            
                            Text(finding)
                                .font(.body)
                                .foregroundColor(.gray)
                                .lineSpacing(2)
                        }
                    }
                }
            }
            
            Spacer(minLength: 100)
        }
    }
    
    private func sourcesTab(report: ResearchReport) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Research Sources")
                .font(.headline)
                .foregroundColor(.white)
            
            LazyVStack(spacing: 12) {
                ForEach(report.sources) { source in
                    ResearchCardView(source: source)
                }
            }
            
            Spacer(minLength: 100)
        }
    }
    
    private func analysisTab(report: ResearchReport) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // Risk Assessment
            VStack(alignment: .leading, spacing: 12) {
                Text("Risk Assessment")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    Text(report.analysis.level.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(riskColor(report.analysis.level))
                    
                    Spacer()
                    
                    Text("Score: \(report.analysis.score)/100")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                )
            }
            
            // Recommendations
            VStack(alignment: .leading, spacing: 12) {
                Text("Recommendations")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(report.analysis.recommendations.enumerated()), id: \.offset) { index, recommendation in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title3)
                            
                            Text(recommendation)
                                .font(.body)
                                .foregroundColor(.gray)
                                .lineSpacing(2)
                        }
                    }
                }
            }
            
            // Concerns
            if !report.analysis.concerns.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Key Concerns")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(report.analysis.concerns.enumerated()), id: \.offset) { index, concern in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                    .font(.title3)
                                
                                Text(concern)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .lineSpacing(2)
                            }
                        }
                    }
                }
            }
            
            Spacer(minLength: 100)
        }
    }
    
    private func riskColor(_ level: RiskAnalysis.RiskLevel) -> Color {
        switch level {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .orange
        case .critical:
            return .red
        }
    }
    
    private func loadResearchData() {
        isLoading = true
        
        Task {
            do {
                // Mock data for now - replace with actual API call
                let mockReport = ResearchReport(
                    id: "mock-research",
                    title: "Labor Conditions Investigation",
                    company: "TechCorp Inc.",
                    summary: "Comprehensive analysis of labor conditions, union activity, and worker rights at TechCorp Inc. This investigation reveals significant concerns about worker treatment and union suppression efforts.",
                    keyFindings: [
                        "Recent unionization efforts in Seattle office",
                        "Wage disparities between departments",
                        "Safety concerns in manufacturing facilities",
                        "Management response to union activities"
                    ],
                    sources: [
                        ResearchSource(title: "NLRB Filing Documents", type: .legal, url: nil, date: Date(), relevance: 0.95),
                        ResearchSource(title: "Employee Testimonies", type: .interview, url: nil, date: Date(), relevance: 0.88),
                        ResearchSource(title: "Financial Reports", type: .financial, url: nil, date: Date(), relevance: 0.75),
                        ResearchSource(title: "News Articles", type: .news, url: nil, date: Date(), relevance: 0.82)
                    ],
                    analysis: RiskAnalysis(
                        level: .high,
                        score: 78,
                        recommendations: [
                            "Support union organizing efforts",
                            "Document wage disparities",
                            "Report safety violations to OSHA",
                            "Connect with existing union members"
                        ],
                        concerns: [
                            "Anti-union tactics by management",
                            "Inadequate safety protocols",
                            "Wage discrimination patterns"
                        ]
                    ),
                    createdAt: Date(),
                    updatedAt: Date()
                )
                
                await MainActor.run {
                    self.researchReport = mockReport
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func shareReport() {
        // Implement sharing functionality
    }
    
    private func exportReport() {
        // Implement export functionality
    }
}

#Preview {
    ResearchView(isPresented: .constant(true))
}
