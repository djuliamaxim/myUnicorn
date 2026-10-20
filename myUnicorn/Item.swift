import Foundation
import SwiftUI
import CoreLocation

struct IndustryDistribution: Identifiable {
    let id = UUID()
    let industry: String
    let companyCount: Int
}

struct GrowthTimeline: Identifiable {
    let id = UUID()
    let year: Int
    let totalUnicorns: Int
}

struct CountryValueNode: Identifiable {
    let id = UUID()
    let country: String
    let totalValuation: Double
    let displayValue: String
    let color: Color
}

struct TechHubLocation: Identifiable {
    let id = UUID()
    let city: String
    let country: String
    let companyCount: Int
    let totalValuation: String
    let coordinate: CLLocationCoordinate2D
}

struct CompanyScatterPoint: Identifiable {
    let id = UUID()
    let company: String
    let totalRaised: Double // Raw double in USD
    let valuation: Double   // Raw double in USD
    let industry: String
}
