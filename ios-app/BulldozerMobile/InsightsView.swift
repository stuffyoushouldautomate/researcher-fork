//
//  InsightsView.swift
//  BulldozerMobile
//
//  Created by Bulldozer AI Team
//  Copyright © 2025 Bulldozer™. All rights reserved.
//

import SwiftUI
import Charts

struct InsightsView: View {
    @EnvironmentObject var insightsManager: InsightsManager
    @State private var selectedCategory: Insight.InsightCategory?
    @State private var searchText = ""
    @State private var showingInsightDetail = false
    @State private var selectedInsight: Insight?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding()
                
                // Category Filter
                CategoryFilter(selectedCategory: $selectedCategory)
                    .padding(.horizontal)
                
                // Insights Content
                if filteredInsights.isEmpty {
                    EmptyInsightsView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredInsights) { insight in
                                InsightCard(insight: insight) {
                                    selectedInsight = insight
                                    showingInsightDetail = true
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("AI Insights")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await insightsManager.refreshInsights()
            }
        }
        .sheet(isPresented: $showingInsightDetail) {
            if let insight = selectedInsight {
                InsightDetailView(insight: insight)
            }
        }
    }
    
    private var filteredInsights: [Insight] {
        let filtered = insightsManager.allInsights.filter { insight in
            if let category = selectedCategory {
                return insight.category == category
            }
            return true
        }
        
        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter { insight in
                insight.title.localizedCaseInsensitiveContains(searchText) ||
                insight.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct CategoryFilter: View {
    @Binding var selectedCategory: Insight.InsightCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    title: "All",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                ForEach(Insight.InsightCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.rawValue.capitalized,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryChip: View {
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

struct InsightCard: View {
    let insight: Insight
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(insight.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Text(insight.discoveredAt, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                ConfidenceIndicator(confidence: insight.confidence)
            }
            
            // Content Preview
            Text(insight.content)
                .font(.body)
                .lineLimit(3)
                .foregroundColor(.secondary)
            
            // Footer
            HStack {
                CategoryBadge(category: insight.category)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "link")
                        .font(.caption)
                    Text("\(insight.sources.count) sources")
                        .font(.caption)
                }
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

struct ConfidenceIndicator: View {
    let confidence: Double
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(Color(.systemGray4), lineWidth: 3)
                    .frame(width: 30, height: 30)
                
                Circle()
                    .trim(from: 0, to: confidence)
                    .stroke(confidenceColor, lineWidth: 3)
                    .frame(width: 30, height: 30)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(confidence * 100))")
                    .font(.caption2)
                    .fontWeight(.bold)
            }
            
            Text("Confidence")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
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

struct CategoryBadge: View {
    let category: Insight.InsightCategory
    
    var body: some View {
        Text(category.rawValue.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(categoryColor.opacity(0.2))
            .foregroundColor(categoryColor)
            .cornerRadius(8)
    }
    
    private var categoryColor: Color {
        switch category {
        case .trend: return .blue
        case .pattern: return .green
        case .correlation: return .purple
        case .prediction: return .orange
        case .recommendation: return .red
        }
    }
}

struct EmptyInsightsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Insights Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Your Bulldozer AI agent will discover insights as it processes research tasks. Check back after completing some tasks!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct InsightDetailView: View {
    let insight: Insight
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text(insight.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            CategoryBadge(category: insight.category)
                            ConfidenceIndicator(confidence: insight.confidence)
                            Spacer()
                        }
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Insight Details")
                            .font(.headline)
                        
                        Text(insight.content)
                            .font(.body)
                            .lineSpacing(6)
                    }
                    
                    // Sources
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sources (\(insight.sources.count))")
                            .font(.headline)
                        
                        ForEach(insight.sources, id: \.self) { source in
                            HStack {
                                Image(systemName: "link")
                                    .foregroundColor(.orange)
                                Text(source)
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    // Metadata
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Discovery Details")
                            .font(.headline)
                        
                        DetailRow(label: "Discovered", value: insight.discoveredAt.formatted(date: .abbreviated, time: .shortened))
                        DetailRow(label: "Category", value: insight.category.rawValue.capitalized)
                        DetailRow(label: "Confidence", value: "\(Int(insight.confidence * 100))%")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Insight Details")
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

#Preview {
    InsightsView()
        .environmentObject(InsightsManager())
}
