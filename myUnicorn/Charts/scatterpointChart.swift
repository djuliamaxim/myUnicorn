//
//  scatterpointChart.swift
//  myUnicorn
//
//  Created by maximjl on 5/26/26.
//

import SwiftUI
import Charts

struct scatterpointChart: View {
    private var topValuationCompany: CompanyScatterPoint? {
        scatterData.max { $0.valuation < $1.valuation }
    }
    
    private var totalRaised: Double {
        scatterData.reduce(0) { $0 + $1.totalRaised }
    }
    
    private var maxRaisedBillions: Double {
        max((scatterData.map(\.totalRaised).max() ?? 1) / 1_000_000_000, 1)
    }
    
    private var maxValuationBillions: Double {
        max((scatterData.map(\.valuation).max() ?? 1) / 1_000_000_000, 1)
    }
    
    private var highlightedCompanies: Set<String> {
        Set(scatterData.sorted { $0.valuation > $1.valuation }.prefix(3).map(\.company))
    }
    
    private var industries: [String] {
        Array(Set(scatterData.map(\.industry))).sorted()
    }
    
    private var xAxisValues: [Double] {
        [0, 2, 4, 6]
    }
    
    private var yAxisValues: [Double] {
        [0, 50, 100, 150]
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
            Text("Comparing capital raised with current unicorn valuation")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var summaryMetrics: some View {
        HStack(spacing: 12) {
            metricTile(
                title: "Companies",
                value: "\(scatterData.count)",
                caption: "sampled unicorns",
                color: .purple,
                systemImage: "circle.grid.cross.fill"
            )
            
            metricTile(
                title: "Top Value",
                value: topValuationCompany?.company ?? "--",
                caption: formattedBillions(topValuationCompany?.valuation ?? 0),
                color: .purple,
                systemImage: "crown.fill"
            )
        }
    }
    
    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Raised Capital vs. Valuation")
                        .font(.headline)
                    Text("Each point represents one company")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(formattedBillions(totalRaised))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.purple)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.purple.opacity(0.12), in: Capsule())
            }
            
            Chart(scatterData) { item in
                PointMark(
                    x: .value("Total Raised", item.totalRaised / 1_000_000_000),
                    y: .value("Valuation", item.valuation / 1_000_000_000)
                )
                .foregroundStyle(industryColor(for: item.industry))
                .symbolSize(highlightedCompanies.contains(item.company) ? 120 : 72)
                .opacity(highlightedCompanies.contains(item.company) ? 0.95 : 0.75)
                .annotation(position: .top, alignment: .center) {
                    if highlightedCompanies.contains(item.company) {
                        Text(shortCompanyName(item.company))
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color(.secondarySystemGroupedBackground), in: Capsule())
                    }
                }
            }
            .frame(height: 320)
            .chartXScale(domain: 0...(maxRaisedBillions * 1.18))
            .chartYScale(domain: 0...(maxValuationBillions * 1.18))
            .chartXAxis {
                AxisMarks(values: xAxisValues) { value in
                    AxisGridLine()
                        .foregroundStyle(Color(.separator).opacity(0.35))
                    if let doubleValue = value.as(Double.self) {
                        AxisValueLabel {
                            Text(axisBillions(doubleValue))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: yAxisValues) { value in
                    AxisGridLine()
                        .foregroundStyle(Color(.separator).opacity(0.35))
                    if let doubleValue = value.as(Double.self) {
                        AxisValueLabel {
                            Text(axisBillions(doubleValue))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .chartPlotStyle { plotArea in
                plotArea
                    .background(Color(.tertiarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            
            axisCaption
            industryLegend
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private var axisCaption: some View {
        HStack {
            Label("X: total raised", systemImage: "arrow.left.and.right")
            Spacer()
            Label("Y: valuation", systemImage: "arrow.up.and.down")
        }
        .font(.caption2.weight(.medium))
        .foregroundStyle(.secondary)
    }
    
    private var industryLegend: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
            ForEach(industries, id: \.self) { industry in
                HStack(spacing: 8) {
                    Circle()
                        .fill(industryColor(for: industry))
                        .frame(width: 9, height: 9)
                    Text(shortIndustryName(industry))
                        .font(.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
        }
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
    
    private func industryColor(for industry: String) -> Color {
        switch industry {
        case "Artificial intelligence":
            return .purple
        case "Fintech":
            return .purple.opacity(0.78)
        case "Internet software & services":
            return .purple.opacity(0.62)
        case "Cybersecurity":
            return .purple.opacity(0.48)
        case "Data management & analytics":
            return .purple.opacity(0.36)
        default:
            return .gray
        }
    }
    
    private func formattedBillions(_ value: Double) -> String {
        let billions = value / 1_000_000_000
        if billions >= 100 {
            return String(format: "$%.0fB", billions)
        }
        return String(format: "$%.1fB", billions)
    }
    
    private func axisBillions(_ value: Double) -> String {
        if value >= 10 || value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "$%.0fB", value)
        }
        return String(format: "$%.1fB", value)
    }
    
    private func shortCompanyName(_ company: String) -> String {
        switch company {
        case "Bytedance":
            return "ByteDance"
        default:
            return company
        }
    }
    
    private func shortIndustryName(_ industry: String) -> String {
        switch industry {
        case "Artificial intelligence":
            return "AI"
        case "Internet software & services":
            return "Internet software"
        case "Data management & analytics":
            return "Data analytics"
        default:
            return industry
        }
    }
}

#Preview {
    scatterpointChart()
}
