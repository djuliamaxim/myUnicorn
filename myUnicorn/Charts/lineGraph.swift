//
//  SwiftUIView.swift
//  myUnicorn
//
//  Created by maximjl on 5/22/26.
//

import SwiftUI
import Charts

struct lineGraph: View {
    private var latestTotal: Int {
        growthData.last?.totalUnicorns ?? 0
    }
    
    private var startTotal: Int {
        growthData.first?.totalUnicorns ?? 0
    }
    
    private var peakGrowth: (year: Int, change: Int)? {
        guard growthData.count > 1 else { return nil }
        return zip(growthData.dropFirst(), growthData).map { current, previous in
            (year: current.year, change: current.totalUnicorns - previous.totalUnicorns)
        }
        .max { $0.change < $1.change }
    }
    
    private var highlightedYears: Set<Int> {
        [2015, 2020, peakGrowth?.year, growthData.last?.year].compactMap { $0 }.reduce(into: Set<Int>()) { result, year in
            result.insert(year)
        }
    }
    
    private var xAxisYears: [Int] {
        [2011, 2014, 2017, 2020, 2022]
    }
    
    private var yAxisValues: [Int] {
        [0, 250, 500, 750, 1000]
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
            Text("Cumulative growth of $1B+ startups over time")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var summaryMetrics: some View {
        HStack(spacing: 12) {
            metricTile(
                title: "Total",
                value: "\(latestTotal)",
                caption: "unicorns in 2022",
                color: .purple,
                systemImage: "chart.line.uptrend.xyaxis"
            )
            
            metricTile(
                title: "Biggest Jump",
                value: "+\(peakGrowth?.change ?? 0)",
                caption: "in \(peakGrowth?.year ?? 0)",
                color: .purple,
                systemImage: "bolt.fill"
            )
        }
    }
    
    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Cumulative Unicorn Count")
                        .font(.headline)
                    Text("Year-by-year ecosystem expansion")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text("+\(latestTotal - startTotal)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.purple)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.purple.opacity(0.12), in: Capsule())
            }
            
            Chart(growthData) { item in
                AreaMark(
                    x: .value("Year", item.year),
                    y: .value("Total Unicorns", item.totalUnicorns)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple.opacity(0.42), .purple.opacity(0.04)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                LineMark(
                    x: .value("Year", item.year),
                    y: .value("Total Unicorns", item.totalUnicorns)
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
                .foregroundStyle(.purple)
                
                PointMark(
                    x: .value("Year", item.year),
                    y: .value("Total Unicorns", item.totalUnicorns)
                )
                .foregroundStyle(.purple)
                .symbolSize(highlightedYears.contains(item.year) ? 92 : 36)
                .annotation(position: item.year == growthData.last?.year ? .leading : .top, alignment: .center) {
                    if highlightedYears.contains(item.year) {
                        Text("\(item.totalUnicorns)")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.purple)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color(.secondarySystemGroupedBackground), in: Capsule())
                    }
                }
            }
            .frame(height: 320)
            .chartXScale(domain: 2011...2022)
            .chartYScale(domain: 0...1050)
            .chartXAxis {
                AxisMarks(values: xAxisYears) { value in
                    AxisGridLine()
                        .foregroundStyle(Color(.separator).opacity(0.35))
                    if let year = value.as(Int.self) {
                        AxisValueLabel {
                            Text(String(year))
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
                    if let total = value.as(Int.self) {
                        AxisValueLabel {
                            Text("\(total)")
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
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private var axisCaption: some View {
        HStack {
            Label("Year", systemImage: "calendar")
            Spacer()
            Label("Total unicorns", systemImage: "number")
        }
        .font(.caption2.weight(.medium))
        .foregroundStyle(.secondary)
    }
    
    private var insightFooter: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(.secondary)
            
            Text("The ecosystem grew fastest in \(String(peakGrowth?.year ?? 2021)), adding \(peakGrowth?.change ?? 0) unicorns in a single year.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 4)
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
}

#Preview {
    lineGraph()
}
