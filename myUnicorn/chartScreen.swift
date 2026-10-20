//
//  chartScreen.swift
//  myUnicorn
//
//  Created by maximjl on 5/22/26.
//

import SwiftUI

struct chartScreen: View {
    let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
        
        var body: some View {
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing:16) {
                        
                        DashboardCard(
                            title: "Global Explosion",
                            subtitle: "Cumulative unicorn growth over time",
                            systemImage: "chart.line.uptrend.xyaxis",
                            color: .purple,
                            destination: lineGraph()
                        )
                        
                        LazyVGrid(columns: columns, spacing: 16) {
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
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: systemImage)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(color)
                        .padding(5)
                        .background(color.opacity(0.15))
                        .clipShape(Circle())
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundColor(Color(.tertiaryLabel))
                }
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .frame(height: 150)
            // Uses standard iOS adapting colors (handles Dark Mode automatically)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    chartScreen()
}
