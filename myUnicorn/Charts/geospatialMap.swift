//
//  geospatialMap.swift
//  myUnicorn
//
//  Created by maximjl on 5/22/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct geospatialMap: View {
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.0, longitude: -5.0),
            span: MKCoordinateSpan(latitudeDelta: 80.0, longitudeDelta: 300.0)
        )
    )
    
    private var totalCompanies: Int {
        globalHubs.reduce(0) { $0 + $1.companyCount }
    }
    
    private var topHub: TechHubLocation? {
        globalHubs.max { $0.companyCount < $1.companyCount }
    }
    
    private var sortedHubs: [TechHubLocation] {
        globalHubs.sorted { $0.companyCount > $1.companyCount }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                header
                summaryMetrics
                mapCard
                insightFooter
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Geospatial concentration of unicorn clusters worldwide")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var summaryMetrics: some View {
        HStack(spacing: 12) {
            metricTile(
                title: "Hub Total",
                value: "\(totalCompanies)",
                caption: "companies mapped",
                systemImage: "mappin.and.ellipse"
            )
            
            metricTile(
                title: "Top Hub",
                value: topHub?.city ?? "--",
                caption: "\(topHub?.companyCount ?? 0) unicorns",
                systemImage: "crown.fill"
            )
        }
    }
    
    private var mapCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Unicorn Density Map")
                        .font(.headline)
                    Text("Bubble size represents companies per city")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text("\(globalHubs.count) hubs")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.purple)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.purple.opacity(0.12), in: Capsule())
            }
            
            Map(position: $position) {
                ForEach(globalHubs) { hub in
                    MapCircle(center: hub.coordinate, radius: bubbleRadius(for: hub))
                        .foregroundStyle(Color.purple.opacity(0.24))
                        .stroke(Color.purple.opacity(0.42), lineWidth: 1)
                    
                    Annotation(hub.city, coordinate: hub.coordinate, anchor: .center) {
                        DensityBubbleView(hub: hub)
                    }
                }
            }
            .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll))
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            .frame(height: 330)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.purple.opacity(0.16), lineWidth: 1)
            }
            
            hubList
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private var hubList: some View {
        VStack(spacing: 10) {
            ForEach(sortedHubs.prefix(5)) { hub in
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 9, height: 9)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text(hub.city)
                            .font(.caption.weight(.semibold))
                        Text(hub.country)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(hub.totalValuation)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                    
                    Text("\(hub.companyCount)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                        .monospacedDigit()
                        .frame(width: 34, alignment: .trailing)
                }
            }
        }
    }
    
    private var insightFooter: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(.secondary)
            
            Text("San Francisco and New York remain the densest mapped hubs, together representing \(topTwoShare)% of companies in this city sample.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 4)
    }
    
    private var topTwoShare: Int {
        guard totalCompanies > 0 else { return 0 }
        let topTwoTotal = sortedHubs.prefix(2).reduce(0) { $0 + $1.companyCount }
        return Int((Double(topTwoTotal) / Double(totalCompanies) * 100).rounded())
    }
    
    private func bubbleRadius(for hub: TechHubLocation) -> CLLocationDistance {
        90_000 + CLLocationDistance(hub.companyCount) * 7_000
    }
    
    private func metricTile(title: String, value: String, caption: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.purple)
                .frame(width: 28, height: 28)
                .background(Color.purple.opacity(0.14), in: Circle())
            
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

struct DensityBubbleView: View {
    let hub: TechHubLocation
    @State private var showDetails = false
    
    private var bubbleSize: CGFloat {
        let base: CGFloat = 22
        let multiplier = CGFloat(hub.companyCount) * 0.34
        return min(base + multiplier, 74)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.22))
                    .frame(width: bubbleSize + 14, height: bubbleSize + 14)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple, .purple.opacity(0.68)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: bubbleSize, height: bubbleSize)
                    .shadow(color: Color.purple.opacity(0.35), radius: 5, x: 0, y: 3)
                
                Text("\(hub.companyCount)")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .monospacedDigit()
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                    showDetails.toggle()
                }
            }
            
            if showDetails {
                VStack(spacing: 2) {
                    Text(hub.city)
                        .font(.caption.weight(.bold))
                    Text(hub.totalValuation)
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color(.systemBackground).opacity(0.96), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(color: Color.black.opacity(0.12), radius: 5, x: 0, y: 2)
            }
        }
    }
}

#Preview {
    geospatialMap()
}
