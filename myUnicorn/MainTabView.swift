//
//  MainTabView.swift
//  myUnicorn
//
//  Created by maximjl on 5/26/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // TAB 1: DATA VISUALIZATION DASHBOARD
            NavigationStack {
                chartScreen()
            }
            .tabItem {
                Label("Summary", systemImage: "chart.bar.fill")
            }
            
            // TAB 2: AI PREDICTOR
            NavigationStack {
                PredictorView()
            }
            .tabItem {
                Label("AI Predictor", systemImage: "brain.head.profile.fill")
            }
        }
    }
}

#Preview {
    MainTabView()
}
