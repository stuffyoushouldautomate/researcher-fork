//
//  ReportsView.swift
//  BulldozerMobile
//
//  Created by Bulldozer AI Team
//  Copyright © 2025 Bulldozer™. All rights reserved.
//

import SwiftUI
import Charts

struct ReportsView: View {
    @EnvironmentObject var reportManager: ReportManager
    @State private var selectedReport: ResearchReport?
    @State private var showingReportDetail = false
    @State private var searchText = ""
    @State private var selectedFilter: ReportFilter = .all
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and Filter Bar
                VStack(spacing: 12) {
                    SearchBar(text: $searchText)
                    
                    FilterBar(selectedFilter: $selectedFilter)
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Reports List
                if reportManager.reports.isEmpty {
                    EmptyReportsView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredReports) { report in
                                ReportCard(report: report) {
                                    selectedReport = report
                                    showingReportDetail = true
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Research Reports")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await reportManager.refreshReports()
            }
        }
        .sheet(isPresented: $showingReportDetail) {
            if let report = selectedReport {
                ReportDetailView(report: report)
            }
        }
    }
    
    private var filteredReports: [ResearchReport] {
        let filtered = reportManager.reports.filter { report in
            switch selectedFilter {
            case .all:
                return true
            case .recent:
                return Calendar.current.isDate(report.generatedAt, equalTo: Date(), toGranularity: .day)
            case .highConfidence:
                return report.confidence > 0.8
            case .thisWeek:
                return Calendar.current.isDate(report.generatedAt, equalTo: Date(), toGranularity: .weekOfYear)
            }
        }
        
        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter { report in
                report.title.localizedCaseInsensitiveContains(searchText) ||
                report.executiveSummary.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search reports...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button("Clear") {
                    text = ""
                }
                .font(.caption)
                .foregroundColor(.orange)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

enum ReportFilter: String, CaseIterable {
    case all = "All"
    case recent = "Recent"
    case highConfidence = "High Confidence"
    case thisWeek = "This Week"
}

struct FilterBar: View {
    @Binding var selectedFilter: ReportFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ReportFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter
                    ) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.orange : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ReportCard: View {
    let report: ResearchReport
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(report.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Text(report.generatedAt, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                ConfidenceBadge(confidence: report.confidence)
            }
            
            // Executive Summary
            Text(report.executiveSummary)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            // Key Metrics
            HStack(spacing: 16) {
                MetricBadge(
                    icon: "lightbulb.fill",
                    value: "\(report.keyFindings.count)",
                    label: "Findings",
                    color: .orange
                )
                
                MetricBadge(
                    icon: "chart.bar.fill",
                    value: "\(report.dataVisualizations.count)",
                    label: "Charts",
                    color: .blue
                )
                
                MetricBadge(
                    icon: "checkmark.circle.fill",
                    value: "\(report.recommendations.count)",
                    label: "Recommendations",
                    color: .green
                )
                
                Spacer()
            }
            
            // Sources Count
            HStack {
                Image(systemName: "link")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                Text("\(report.sources.count) sources")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
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

struct ConfidenceBadge: View {
    let confidence: Double
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(confidenceColor)
                .font(.caption)
            
            Text("\(Int(confidence * 100))%")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(confidenceColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(confidenceColor.opacity(0.2))
        .cornerRadius(8)
    }
    
    private var confidenceColor: Color {
        if confidence >= 0.8 {
            return .green
        } else if confidence >= 0.6 {
            return .orange
        } else {
            return .red
        }
    }
}

struct MetricBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.caption)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.caption)
                    .fontWeight(.bold)
                
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct EmptyReportsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Reports Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Your Bulldozer AI agent hasn't completed any research tasks yet. Submit a task to get started!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ReportDetailView: View {
    let report: ResearchReport
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSection: ReportSection = .overview
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Section Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(ReportSection.allCases, id: \.self) { section in
                            SectionButton(
                                section: section,
                                isSelected: selectedSection == section
                            ) {
                                selectedSection = section
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        switch selectedSection {
                        case .overview:
                            OverviewSection(report: report)
                        case .findings:
                            FindingsSection(report: report)
                        case .visualizations:
                            VisualizationsSection(report: report)
                        case .recommendations:
                            RecommendationsSection(report: report)
                        case .methodology:
                            MethodologySection(report: report)
                        case .sources:
                            SourcesSection(report: report)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(report.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Share") {
                        // Share functionality
                    }
                }
            }
        }
    }
}

enum ReportSection: String, CaseIterable {
    case overview = "Overview"
    case findings = "Findings"
    case visualizations = "Charts"
    case recommendations = "Recommendations"
    case methodology = "Methodology"
    case sources = "Sources"
}

struct SectionButton: View {
    let section: ReportSection
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(section.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.orange : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OverviewSection: View {
    let report: ResearchReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Executive Summary
            VStack(alignment: .leading, spacing: 12) {
                Text("Executive Summary")
                    .font(.headline)
                
                Text(report.executiveSummary)
                    .font(.body)
                    .lineSpacing(4)
            }
            
            // Key Metrics Overview
            VStack(alignment: .leading, spacing: 12) {
                Text("Key Metrics")
                    .font(.headline)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    OverviewMetricCard(
                        title: "Confidence Score",
                        value: "\(Int(report.confidence * 100))%",
                        icon: "checkmark.circle.fill",
                        color: report.confidence >= 0.8 ? .green : .orange
                    )
                    
                    OverviewMetricCard(
                        title: "Key Findings",
                        value: "\(report.keyFindings.count)",
                        icon: "lightbulb.fill",
                        color: .orange
                    )
                    
                    OverviewMetricCard(
                        title: "Data Visualizations",
                        value: "\(report.dataVisualizations.count)",
                        icon: "chart.bar.fill",
                        color: .blue
                    )
                    
                    OverviewMetricCard(
                        title: "Recommendations",
                        value: "\(report.recommendations.count)",
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                }
            }
            
            // Report Metadata
            VStack(alignment: .leading, spacing: 12) {
                Text("Report Details")
                    .font(.headline)
                
                VStack(spacing: 8) {
                    DetailRow(label: "Generated", value: report.generatedAt.formatted(date: .abbreviated, time: .shortened))
                    DetailRow(label: "Sources", value: "\(report.sources.count)")
                    DetailRow(label: "Methodology", value: report.methodology)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
    }
}

struct OverviewMetricCard: View {
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

struct DetailRow: View {
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

struct FindingsSection: View {
    let report: ResearchReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Key Findings")
                .font(.headline)
            
            ForEach(report.keyFindings) { finding in
                FindingCard(finding: finding)
            }
        }
    }
}

struct FindingCard: View {
    let finding: KeyFinding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(finding.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                ImpactBadge(impact: finding.impact)
            }
            
            Text(finding.description)
                .font(.body)
                .lineSpacing(4)
            
            if !finding.evidence.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Evidence:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    ForEach(finding.evidence, id: \.self) { evidence in
                        HStack(alignment: .top) {
                            Text("•")
                                .foregroundColor(.orange)
                            Text(evidence)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct ImpactBadge: View {
    let impact: KeyFinding.ImpactLevel
    
    var body: some View {
        Text(impact.rawValue.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(impactColor.opacity(0.2))
            .foregroundColor(impactColor)
            .cornerRadius(6)
    }
    
    private var impactColor: Color {
        switch impact {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        case .critical: return .purple
        }
    }
}

struct VisualizationsSection: View {
    let report: ResearchReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Data Visualizations")
                .font(.headline)
            
            if report.dataVisualizations.isEmpty {
                Text("No visualizations available for this report")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(report.dataVisualizations) { visualization in
                    VisualizationCard(visualization: visualization)
                }
            }
        }
    }
}

struct VisualizationCard: View {
    let visualization: DataVisualization
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(visualization.title)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            // Simple chart representation
            Chart(visualization.data, id: \.label) { dataPoint in
                BarMark(
                    x: .value("Label", dataPoint.label),
                    y: .value("Value", dataPoint.value)
                )
                .foregroundStyle(Color.orange)
            }
            .frame(height: 200)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct RecommendationsSection: View {
    let report: ResearchReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommendations")
                .font(.headline)
            
            ForEach(report.recommendations) { recommendation in
                RecommendationCard(recommendation: recommendation)
            }
        }
    }
}

struct RecommendationCard: View {
    let recommendation: Recommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(recommendation.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                PriorityBadge(priority: recommendation.priority)
            }
            
            Text(recommendation.description)
                .font(.body)
                .lineSpacing(4)
            
            if !recommendation.implementationSteps.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Implementation Steps:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    ForEach(Array(recommendation.implementationSteps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .foregroundColor(.orange)
                                .fontWeight(.medium)
                            Text(step)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            if !recommendation.expectedOutcome.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Expected Outcome:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text(recommendation.expectedOutcome)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct PriorityBadge: View {
    let priority: TaskPriority
    
    var body: some View {
        Text(priority.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(priority.color.opacity(0.2))
            .foregroundColor(priority.color)
            .cornerRadius(6)
    }
}

struct MethodologySection: View {
    let report: ResearchReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Methodology")
                .font(.headline)
            
            Text(report.methodology)
                .font(.body)
                .lineSpacing(4)
        }
    }
}

struct SourcesSection: View {
    let report: ResearchReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sources (\(report.sources.count))")
                .font(.headline)
            
            ForEach(report.sources) { source in
                SourceCard(source: source)
            }
        }
    }
}

struct SourceCard: View {
    let source: Resource
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: sourceIcon)
                .foregroundColor(.orange)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(source.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Text(source.url)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text(source.type.rawValue.capitalized)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    Text("\(Int(source.relevanceScore * 100))% relevance")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private var sourceIcon: String {
        switch source.type {
        case .article: return "doc.text.fill"
        case .paper: return "doc.plaintext.fill"
        case .video: return "play.rectangle.fill"
        case .podcast: return "waveform"
        case .data: return "chart.bar.fill"
        case .tool: return "wrench.fill"
        }
    }
}

#Preview {
    ReportsView()
        .environmentObject(ReportManager())
}
