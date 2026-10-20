//
//  myData.swift
//  myUnicorn
//
//  Created by maximjl on 5/19/26.
//

import Foundation
import SwiftUI
import CoreLocation

let industryData: [IndustryDistribution] = [
    IndustryDistribution(industry: "Fintech", companyCount: 189),
    IndustryDistribution(industry: "Internet software & services", companyCount: 179),
    IndustryDistribution(industry: "E-commerce & direct-to-consumer", companyCount: 100),
    IndustryDistribution(industry: "Artificial intelligence", companyCount: 72),
    IndustryDistribution(industry: "Health", companyCount: 65),
    IndustryDistribution(industry: "Other", companyCount: 52),
    IndustryDistribution(industry: "Supply chain, logistics, & delivery", companyCount: 52),
    IndustryDistribution(industry: "Cybersecurity", companyCount: 48),
    IndustryDistribution(industry: "Data management & analytics", companyCount: 39),
    IndustryDistribution(industry: "Hardware", companyCount: 32),
    IndustryDistribution(industry: "Mobile & telecommunications", companyCount: 29),
    IndustryDistribution(industry: "Edtech", companyCount: 27),
    IndustryDistribution(industry: "Auto & transportation", companyCount: 25),
    IndustryDistribution(industry: "Consumer & retail", companyCount: 23),
    IndustryDistribution(industry: "Travel", companyCount: 14)
]

let growthData: [GrowthTimeline] = [
    GrowthTimeline(year: 2011, totalUnicorns: 2),
    GrowthTimeline(year: 2012, totalUnicorns: 6),
    GrowthTimeline(year: 2013, totalUnicorns: 9),
    GrowthTimeline(year: 2014, totalUnicorns: 21),
    GrowthTimeline(year: 2015, totalUnicorns: 52),
    GrowthTimeline(year: 2016, totalUnicorns: 71),
    GrowthTimeline(year: 2017, totalUnicorns: 112),
    GrowthTimeline(year: 2018, totalUnicorns: 206),
    GrowthTimeline(year: 2019, totalUnicorns: 299),
    GrowthTimeline(year: 2020, totalUnicorns: 399),
    GrowthTimeline(year: 2021, totalUnicorns: 865),
    GrowthTimeline(year: 2022, totalUnicorns: 946)
]

let treemapData: [CountryValueNode] = [
        CountryValueNode(country: "United States", totalValuation: 1_933_000_000_000, displayValue: "$1.93T", color: .blue),
        CountryValueNode(country: "China", totalValuation: 569_000_000_000, displayValue: "$569B", color: .red),
        CountryValueNode(country: "Other Countries", totalValuation: 391_000_000_000, displayValue: "$391B", color: .gray),
        CountryValueNode(country: "United Kingdom", totalValuation: 150_000_000_000, displayValue: "$150B", color: .orange),
        CountryValueNode(country: "India", totalValuation: 148_000_000_000, displayValue: "$148B", color: .green)
    ]

let globalHubs: [TechHubLocation] = [
    TechHubLocation(city: "San Francisco", country: "United States", companyCount: 152, totalValuation: "$720B", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
    TechHubLocation(city: "New York", country: "United States", companyCount: 103, totalValuation: "$311B", coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)),
    TechHubLocation(city: "Beijing", country: "China", companyCount: 63, totalValuation: "$294B", coordinate: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074)),
    TechHubLocation(city: "Shanghai", country: "China", companyCount: 44, totalValuation: "$118B", coordinate: CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737)),
    TechHubLocation(city: "London", country: "United Kingdom", companyCount: 34, totalValuation: "$92B", coordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)),
    TechHubLocation(city: "Bengaluru", country: "India", companyCount: 29, totalValuation: "$83B", coordinate: CLLocationCoordinate2D(latitude: 12.9716, longitude: 77.5946)),
    TechHubLocation(city: "Shenzhen", country: "China", companyCount: 19, totalValuation: "$42B", coordinate: CLLocationCoordinate2D(latitude: 22.5431, longitude: 114.0579))
]

let scatterData: [CompanyScatterPoint] = [
    CompanyScatterPoint(company: "Bytedance", totalRaised: 7_440_000_000, valuation: 140_000_000_000, industry: "Artificial intelligence"),
    CompanyScatterPoint(company: "SpaceX", totalRaised: 6_874_000_000, valuation: 100_300_000_000, industry: "Other"),
    CompanyScatterPoint(company: "Stripe", totalRaised: 2_901_000_000, valuation: 95_000_000_000, industry: "Fintech"),
    CompanyScatterPoint(company: "Klarna", totalRaised: 3_472_000_000, valuation: 45_600_000_000, industry: "Fintech"),
    CompanyScatterPoint(company: "Epic Games", totalRaised: 4_377_000_000, valuation: 42_000_000_000, industry: "Other"),
    CompanyScatterPoint(company: "Chime", totalRaised: 2_300_000_000, valuation: 25_000_000_000, industry: "Fintech"),
    CompanyScatterPoint(company: "Miro", totalRaised: 476_000_000, valuation: 17_500_000_000, industry: "Internet software & services"),
    CompanyScatterPoint(company: "Discord", totalRaised: 983_000_000, valuation: 15_000_000_000, industry: "Internet software & services"),
    CompanyScatterPoint(company: "Celonis", totalRaised: 1_400_000_000, valuation: 13_000_000_000, industry: "Data management & analytics"),
    CompanyScatterPoint(company: "Snyk", totalRaised: 850_000_000, valuation: 8_500_000_000, industry: "Cybersecurity"),
    CompanyScatterPoint(company: "Figma", totalRaised: 333_000_000, valuation: 10_000_000_000, industry: "Internet software & services"),
    CompanyScatterPoint(company: "Verkada", totalRaised: 139_000_000, valuation: 1_600_000_000, industry: "Cybersecurity")
]
