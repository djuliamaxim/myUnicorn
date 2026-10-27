//
//  chartScreen.swift
//  myUnicorn
//
//  Created by maximjl on 5/22/26.
//

import SwiftUI

struct chartScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    DashboardCard(
                        title: "Global Trends",
                        subtitle: "Cumulative unicorn growth over time",
                        systemImage: "chart.line.uptrend.xyaxis",
                        color: .purple,
                        destination: lineGraph()
                    )
                    
                    DashboardCard(
                        title: "Industries",
                        subtitle: "Sector distribution",
                        systemImage: "chart.bar.fill",
                        color: .purple,
                        destination: barChart()
                    )
                    
                    DashboardCard(
                        title: "Market Share",
                        subtitle: "Valuation treemap",
                        systemImage: "chart.pie.fill",
                        color: .purple,
                        destination: treeMap()
                    )
                    
                    DashboardCard(
                        title: "Correlations",
                        subtitle: "Funding vs Valuation",
                        systemImage: "chart.xyaxis.line",
                        color: .purple,
                        destination: scatterpointChart()
                    )
                    
                    DashboardCard(
                        title: "Global Hubs",
                        subtitle: "World density map",
                        systemImage: "map.fill",
                        color: .purple,
                        destination: geospatialMap()
                    )
                }
                .padding()
            }
            .navigationTitle("Summary")
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

struct DashboardCard<Destination: View>: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination.navigationTitle(title)) {
            HStack(spacing: 16) {
                // Icon Badge
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 36, height: 36)
                    .background(color.opacity(0.15))
                    .clipShape(Circle())
                
                // Text Content Stack
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Chevron Indicator
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            // Uses standard iOS adapting background colors (handles Dark Mode automatically)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
        }
    }
}

#Preview {
    chartScreen()
}
