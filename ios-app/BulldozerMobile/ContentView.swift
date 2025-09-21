//
//  ContentView.swift
//  BulldozerMobile
//
//  Created by Bulldozer Team on 2025.
//  Copyright © 2025 Bulldozer. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showingResearch = false
    
    var body: some View {
        ZStack {
            // Background gradient for premium feel
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.05, green: 0.05, blue: 0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if showingResearch {
                ResearchView(isPresented: $showingResearch)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .trailing)
                    ))
            } else {
                ChatView(showingResearch: $showingResearch)
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .leading)
                    ))
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showingResearch)
        .gesture(
            DragGesture()
                .onEnded { value in
                    let threshold: CGFloat = 100
                    if value.translation.x > threshold && !showingResearch {
                        showingResearch = true
                    } else if value.translation.x < -threshold && showingResearch {
                        showingResearch = false
                    }
                }
        )
    }
}

#Preview {
    ContentView()
}
