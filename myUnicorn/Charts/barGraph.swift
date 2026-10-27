//
//  chartView.swift
//  myUnicorn
//
//  Created by maximjl on 5/19/26.
//

import SwiftUI

struct barChart: View {
    private var sortedIndustryData: [IndustryDistribution] {
        industryData.sorted { $0.companyCount > $1.companyCount }
    }
    
    private var totalCompanies: Int {
        industryData.reduce(0) { $0 + $1.companyCount }
    }
    
    private var topIndustry: IndustryDistribution? {
        sortedIndustryData.first
    }
    
    private var averageCompanyCount: Int {
        guard !industryData.isEmpty else { return 0 }
        return totalCompanies / industryData.count
    }
    
    private var maxCompanyCount: Int {
        max(sortedIndustryData.first?.companyCount ?? 1, 1)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                header
                summaryMetrics
                chartCard
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Where billion-dollar startups are concentrated by sector")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var summaryMetrics: some View {
        HStack(spacing: 12) {
            metricTile(
                title: "Total",
                value: "\(totalCompanies)",
                caption: "unicorns",
                color: .purple,
                systemImage: "building.2.fill"
            )
            
            metricTile(
                title: "Leader",
                value: topIndustry?.industry ?? "--",
                caption: "\(topIndustry?.companyCount ?? 0) companies",
                color: .purple,
                systemImage: "crown.fill"
            )
        }
    }
    
    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Companies by Industry")
                        .font(.headline)
                    Text("Sorted from largest to smallest sector")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text("Avg \(averageCompanyCount)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.purple)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.purple.opacity(0.12), in: Capsule())
            }
            
            VStack(spacing: 10) {
                axisLegend
                industryBars
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private var axisLegend: some View {
        HStack {
            Text("Industry")
                .frame(width: 118, alignment: .leading)
            Text("0")
            Spacer()
            Text("\(maxCompanyCount)")
        }
        .font(.caption2.weight(.medium))
        .foregroundStyle(.secondary)
    }
    
    private var industryBars: some View {
        VStack(spacing: 12) {
            ForEach(sortedIndustryData) { item in
                industryRow(for: item)
            }
        }
    }
    
    private func industryRow(for item: IndustryDistribution) -> some View {
        HStack(spacing: 10) {
            Text(shortIndustryName(item.industry))
                .font(.caption.weight(item.id == topIndustry?.id ? .semibold : .regular))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(width: 118, alignment: .leading)
            
            GeometryReader { geometry in
                let width = geometry.size.width * CGFloat(item.companyCount) / CGFloat(maxCompanyCount)
                
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.tertiarySystemFill))
                    Capsule()
                        .fill(barColor(for: item))
                        .frame(width: max(width, 8))
                }
            }
            .frame(height: 16)
            
            Text("\(item.companyCount)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .monospacedDigit()
                .frame(width: 34, alignment: .trailing)
        }
        .frame(height: 24)
    }
    
    
    private var topTwoShare: Int {
        guard totalCompanies > 0 else { return 0 }
        let topTwoTotal = sortedIndustryData.prefix(2).reduce(0) { $0 + $1.companyCount }
        return Int((Double(topTwoTotal) / Double(totalCompanies) * 100).rounded())
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
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
    
    private func barColor(for item: IndustryDistribution) -> Color {
        guard let topIndustry else { return .purple }
        return item.id == topIndustry.id ? .purple : .purple.opacity(0.68)
    }
    
    private func shortIndustryName(_ industry: String) -> String {
        switch industry {
        case "Internet software & services":
            return "Internet software"
        case "E-commerce & direct-to-consumer":
            return "E-commerce"
        case "Artificial intelligence":
            return "AI"
        case "Supply chain, logistics, & delivery":
            return "Supply chain"
        case "Data management & analytics":
            return "Data analytics"
        case "Mobile & telecommunications":
            return "Mobile & telecom"
        case "Auto & transportation":
            return "Auto & transport"
        case "Consumer & retail":
            return "Consumer retail"
        default:
            return industry
        }
    }
}

#Preview {
    barChart()
}
