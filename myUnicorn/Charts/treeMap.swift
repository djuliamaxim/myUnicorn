//
//  treeMap.swift
//  myUnicorn
//
//  Created by maximjl on 5/22/26.
//

import SwiftUI

struct treeMap: View {
    private var sortedTreemapData: [CountryValueNode] {
        Array(treemapData.sorted { $0.totalValuation > $1.totalValuation }.prefix(5))
    }
    
    private var totalValuation: Double {
        treemapData.reduce(0) { $0 + $1.totalValuation }
    }
    
    private var topCountry: CountryValueNode? {
        sortedTreemapData.first
    }
    
    private var topCountryShare: Int {
        share(for: topCountry)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                header
                summaryMetrics
                chartCard
                insightFooter
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("How unicorn market value is distributed by country")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var summaryMetrics: some View {
        HStack(spacing: 12) {
            metricTile(
                title: "Total Value",
                value: formattedValuation(totalValuation),
                caption: "tracked market cap",
                color: .purple,
                systemImage: "chart.pie.fill"
            )
            
            metricTile(
                title: "Leader",
                value: topCountry?.country ?? "--",
                caption: "\(topCountryShare)% of value",
                color: .purple,
                systemImage: "crown.fill"
            )
        }
    }
    
    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Valuation by Country")
                        .font(.headline)
                    Text("Tile size represents total valuation")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text("Top \(topCountryShare)%")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.purple)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.purple.opacity(0.12), in: Capsule())
            }
            
            treemapCanvas
            countryLegend
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private var treemapCanvas: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 8
            let fullWidth = geometry.size.width
            let fullHeight = geometry.size.height
            let leftWidth = fullWidth * shareRatio(for: sortedTreemapData[safe: 0])
            let rightWidth = max(fullWidth - leftWidth - spacing, 0)
            let rightData = Array(sortedTreemapData.dropFirst())
            let rightTotal = max(rightData.reduce(0) { $0 + $1.totalValuation }, 1)
            let topRightHeight = fullHeight * CGFloat((rightData.first?.totalValuation ?? 0) / rightTotal)
            let bottomHeight = max(fullHeight - topRightHeight - spacing, 0)
            
            HStack(spacing: spacing) {
                if let largest = sortedTreemapData[safe: 0] {
                    treemapBlock(node: largest, isPrimary: true)
                        .frame(width: max(leftWidth, 0), height: fullHeight)
                }
                
                VStack(spacing: spacing) {
                    if let second = rightData.first {
                        treemapBlock(node: second, isPrimary: false)
                            .frame(width: rightWidth, height: max(topRightHeight, 0))
                    }
                    
                    HStack(spacing: spacing) {
                        let remainingData = Array(rightData.dropFirst())
                        let remainingTotal = max(remainingData.reduce(0) { $0 + $1.totalValuation }, 1)
                        
                        ForEach(remainingData) { node in
                            let width = rightWidth * CGFloat(node.totalValuation / remainingTotal)
                            treemapBlock(node: node, isPrimary: false)
                                .frame(width: max(width - spacing, 0), height: bottomHeight)
                        }
                    }
                    .frame(width: rightWidth, height: bottomHeight)
                }
                .frame(width: rightWidth, height: fullHeight)
            }
        }
        .frame(height: 280)
    }
    
    private var countryLegend: some View {
        VStack(spacing: 10) {
            ForEach(sortedTreemapData) { node in
                HStack(spacing: 10) {
                    Circle()
                        .fill(treemapColor(for: node))
                        .frame(width: 10, height: 10)
                    
                    Text(node.country)
                        .font(.caption)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(node.displayValue)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                    
                    Text("\(share(for: node))%")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                        .monospacedDigit()
                        .frame(width: 38, alignment: .trailing)
                }
            }
        }
        .padding(.top, 2)
    }
    
    private var insightFooter: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(.secondary)
            
            Text("The United States holds \(topCountryShare)% of tracked unicorn value, making it the dominant market in this dataset.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 4)
    }
    
    private func treemapBlock(node: CountryValueNode, isPrimary: Bool) -> some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(treemapColor(for: node).gradient)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(shortCountryName(node.country))
                    .font(isPrimary ? .headline.weight(.bold) : .caption.weight(.bold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                
                Text(node.displayValue)
                    .font(.caption.weight(.semibold))
                    .monospacedDigit()
                    .opacity(0.95)
                
                Text("\(share(for: node))%")
                    .font(.caption2.weight(.semibold))
                    .opacity(0.85)
            }
            .foregroundStyle(.white)
            .padding(isPrimary ? 14 : 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [.black.opacity(0), .black.opacity(0.28)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private func metricTile(title: String, value: String, caption: String, color: Color, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(color)
                .frame(width: 28, height: 28)
                .background(color.opacity(0.14), in: Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.headline.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                Text(caption)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
    
    private func treemapColor(for node: CountryValueNode) -> Color {
        switch node.country {
        case "United States":
            return .purple
        case "China":
            return .purple.opacity(0.78)
        case "Other Countries":
            return .purple.opacity(0.58)
        case "United Kingdom":
            return .purple.opacity(0.46)
        case "India":
            return .purple.opacity(0.36)
        default:
            return .purple.opacity(0.6)
        }
    }
    
    private func shareRatio(for node: CountryValueNode?) -> CGFloat {
        guard let node, totalValuation > 0 else { return 0 }
        return CGFloat(node.totalValuation / totalValuation)
    }
    
    private func share(for node: CountryValueNode?) -> Int {
        guard let node, totalValuation > 0 else { return 0 }
        return Int((node.totalValuation / totalValuation * 100).rounded())
    }
    
    private func formattedValuation(_ value: Double) -> String {
        if value >= 1_000_000_000_000 {
            return String(format: "$%.2fT", value / 1_000_000_000_000)
        }
        return String(format: "$%.0fB", value / 1_000_000_000)
    }
    
    private func shortCountryName(_ country: String) -> String {
        switch country {
        case "United States":
            return "U.S."
        case "United Kingdom":
            return "U.K."
        case "Other Countries":
            return "Other"
        default:
            return country
        }
    }
}

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    treeMap()
}
