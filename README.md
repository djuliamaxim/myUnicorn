# myUnicorn AI 🦄

[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple.svg)](https://developer.apple.com/xcode/swiftui/)
[![CoreML](https://img.shields.io/badge/ML-Core%20ML-green.svg)](https://developer.apple.com/documentation/coreml)
[![Swift Charts](https://img.shields.io/badge/Visualizations-Swift%20Charts%20%7C%20MapKit-indigo.svg)](https://developer.apple.com/documentation/charts)

**myUnicorn AI** is a native iOS application designed to explore, visualize, and predict valuation dynamics across global billion-dollar private startups ("unicorns"). Combining interactive exploratory data analysis with privacy-first on-device machine learning, the app delivers macro industry insights, geospatial clustering, funding-to-valuation correlations, and on-demand valuation tier predictions.

---

## Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
  - [1. Onboarding & Executive Dashboard](#1-onboarding--executive-dashboard)
  - [2. Deep-Dive Analytical Visualizations](#2-deep-dive-analytical-visualizations)
  - [3. On-Device AI Valuation Predictor](#3-on-device-ai-valuation-predictor)
- [Machine Learning Architecture](#-machine-learning-architecture)
- [Project Architecture & Directory Structure](#-project-architecture--directory-structure)
- [Data Specifications & Benchmarks](#-data-specifications--benchmarks)
- [Tech Stack & Frameworks](#-tech-stack--frameworks)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Build and Run](#build-and-run)
  - [Running Tests](#running-tests)
- [Author & License](#-author--license)

---

## Overview

In venture capital and tech ecosystems, a **Unicorn** refers to a privately held startup company valued at **$1 billion or more**. As private market investments and startup valuations rapidly evolved over the past decade, understanding growth trends, industry leadership, capital efficiency, and geographical distribution has become essential.

**myUnicorn** solves this by:
1. Translating global startup datasets into **five dedicated, interactive visualization views** built with Apple's **Swift Charts** and **MapKit**.
2. Integrating a trained **Core ML classifier** (`FinalUnicornPredictor.mlmodel`) to predict whether a startup belongs in a **High** or **Low** valuation tier based on its core operational and funding signals—executed entirely on-device with zero server latency.

---

## 🚀 Key Features

### 1. Onboarding & Executive Dashboard
- **Welcome Experience ([`ContentView.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/ContentView.swift))**: Educational landing screen introducing unicorn fundamentals, core capability highlights (Charts, Maps, AI Model), and a spring-animated gateway into the main dashboard.
- **Executive Hub ([`chartScreen.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/chartScreen.swift))**: Card-based navigation interface displaying quick links to individual chart modules with custom SF Symbols and secondary grouped styling.
- **Persistent Tab Navigation ([`MainTabView.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/MainTabView.swift))**: Seamless switching between the **Summary** dashboard and the **AI Predictor** workspace.

### 2. Deep-Dive Analytical Visualizations

| Module | File | Framework | Key Capabilities |
| :--- | :--- | :--- | :--- |
| **Global Explosion** | [`lineGraph.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/Charts/lineGraph.swift) | `Charts` | Cumulative growth curve (2011–2022) with Catmull-Rom smoothed `AreaMark`, `LineMark`, and annotated `PointMark` milestones highlighting the record surge in 2021 (+466 unicorns). |
| **Industries** | [`barGraph.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/Charts/barGraph.swift) | `SwiftUI` | Ranked horizontal bar chart comparing 15 startup sectors. Features dynamic KPI tiles and shows Fintech (189 companies) and Internet Software (179 companies) dominating 41% of all unicorns. |
| **Market Share** | [`treeMap.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/Charts/treeMap.swift) | `SwiftUI` | Custom proportional 2D spatial treemap displaying global valuation concentration. Highlights United States leadership ($1.93T / 61% share) followed by China, the UK, and India. |
| **Correlations** | [`scatterpointChart.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/Charts/scatterpointChart.swift) | `Charts` | Interactive scatter plot measuring Capital Raised ($B) against Valuation ($B) across companies like ByteDance, SpaceX, Stripe, and Klarna, with industry color-coding and trend insights. |
| **Global Hubs** | [`geospatialMap.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/Charts/geospatialMap.swift) | `MapKit` | World density map plotting metropolitan clusters (San Francisco, New York, Beijing, Shanghai, London, Bengaluru, Shenzhen) using proportional `MapCircle` radii and tap-to-inspect `DensityBubbleView` overlays. |

### 3. On-Device AI Valuation Predictor
Located in [`predictionView.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/predictionView.swift) and powered by [`predictionModel.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/predictionModel.swift):
- **Interactive Control Sliders**: Real-time manipulation of company metrics with formatted displays (compact USD currency notation, year integers, and elapsed intervals).
- **Core ML Inference Engine**: Evaluates startup parameters via `PredictionService.shared`.
- **Dynamic Result Card**: Displays predicted classification badge (`High` vs `Low`), qualitative interpretation, and an animated probability confidence bar.
- **Privacy-First**: No data leaves the device; inference executes locally using Apple Neural Engine / GPU acceleration.

---

## Machine Learning Architecture

The app bundles a pre-trained machine learning model: **`FinalUnicornPredictor.mlmodel`**.

### Input Features

| Feature Name | Swift Type | Model Input Key | Operational Range | Default | Unit / Format |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Founded Year** | `Double` | `Founded_Year` | `2000 – 2026` | `2015` | Year (`YYYY`) |
| **Total Raised** | `Double` | `Total_Raised` | `$1M – $5B` | `$250M` | USD (`$10M` step) |
| **Investors Count** | `Double` | `Investors_Count` | `1 – 80` | `10` | Lead / syndicate investors |
| **Deal Terms** | `Double` | `Deal_Terms` | `1 – 20` | `3` | Funding rounds & terms count |
| **Years to Unicorn** | `Double` | `Years_To_Unicorn` | `1 – 25` | `5` | Years from inception to $1B |

### Output

| Feature | Type | Description |
| :--- | :--- | :--- |
| **Tier** | `String` | Categorical classification: **`High`** (Upper valuation tier) or **`Low`** (Base valuation tier). |
| **classProbability** | `[String: Double]` | Probability distribution used by [`predictionModel.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/predictionModel.swift#L50) to render the model confidence score (0%–100%). |

```swift
// Sample programmatic inference
let result = PredictionService.shared.predictTier(
    foundedYear: 2015,
    totalRaised: 250_000_000,
    investorsCount: 10,
    dealTerms: 3,
    yearsToUnicorn: 5
)

if let result = result {
    print("Predicted Tier: \(result.tier) (\(result.confidence * 100)%)")
}
```

---

## Project Architecture & Directory Structure

```text
myUnicorn/
├── myUnicorn.xcodeproj                 # Xcode project configuration
├── FinalUnicornPredictor.mlmodel       # Bundled Core ML classification model
├── myUnicorn/
│   ├── myUnicornApp.swift              # Application entry point (@main)
│   ├── ContentView.swift               # Welcome / onboarding splash screen
│   ├── MainTabView.swift               # Tab navigation controller
│   ├── chartScreen.swift               # Dashboard grid view with destination links
│   ├── Item.swift                      # Data models & Identifiable structs
│   ├── myData.swift                    # Static sample datasets & global hub constants
│   ├── predictionModel.swift           # PredictionService singleton for Core ML inference
│   ├── predictionView.swift            # Interactive inference UI with sliders & result cards
│   ├── Charts/                         # Specialized data visualization views
│   │   ├── barGraph.swift              # Industry distribution bar chart
│   │   ├── geospatialMap.swift         # MapKit density map & interactive bubbles
│   │   ├── lineGraph.swift             # Cumulative growth timeline chart
│   │   ├── scatterpointChart.swift     # Capital raised vs valuation scatter plot
│   │   └── treeMap.swift               # Country valuation proportional treemap
│   └── Assets.xcassets                 # App icons, accent colors, and asset catalog
├── myUnicornTests/
│   └── myUnicornTests.swift            # Unit test suite (XCTest)
└── myUnicornUITests/
    ├── myUnicornUITests.swift          # UI automation test suite
    └── myUnicornUITestsLaunchTests.swift # Launch performance & snapshot tests
```

### Architectural Principles

- **Declarative SwiftUI**: Clean separation of state (`@State`, `@Binding`) and presentation logic.
- **Service Singleton Pattern**: [`PredictionService`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/predictionModel.swift#L4) initializes `FinalUnicornPredictor` exactly once during application lifecycle to preserve memory and battery.
- **Adaptive Visual Hierarchy**: Utilizes semantic system colors (`Color(.secondarySystemGroupedBackground)`) to natively support **Light Mode** and **Dark Mode** without hardcoded color values.
- **Modular Visualizations**: Every chart view is isolated with its own summary metrics tiles, chart viewport, axis formatting, and automated insight footer.

---

## Data Specifications & Benchmarks

The project embeds structured datasets in [`myData.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/myData.swift) and models defined in [`Item.swift`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/Item.swift):

- **Industry Distribution ([`IndustryDistribution`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/Item.swift#L5-L9))**: 946+ tracked companies across 15 distinct sectors (Fintech, Internet software, AI, E-commerce, Health, Supply Chain, Cybersecurity, etc.).
- **Timeline Growth ([`GrowthTimeline`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/Item.swift#L11-L15))**: Annual cumulative milestones tracking the exponential rise from 2 unicorns in 2011 to nearly 1,000 unicorns in 2022.
- **Country Market Cap Treemap ([`CountryValueNode`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/Item.swift#L17-L23))**: Country-level valuations led by the United States ($1.93T), China ($569B), United Kingdom ($150B), and India ($148B).
- **Tech Hub Geospatial Clusters ([`TechHubLocation`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/Item.swift#L25-L32))**: Exact GPS coordinates (`CLLocationCoordinate2D`), unicorn counts, and cumulative valuations for top global startup cities.
- **Venture Scatter Points ([`CompanyScatterPoint`](file:///Users/maxim/Desktop/specialization/CS192-4P/M1/Activities/myUnicorn/myUnicorn/Item.swift#L34-L40))**: Correlation benchmarks comparing total funding raised with current market valuation.

---

## Tech Stack & Frameworks

| Layer | Framework / Technology | Usage |
| :--- | :--- | :--- |
| **Language** | Swift 5.9+ / Swift 6 | Strict type safety, modern async patterns, modern concurrency |
| **UI Framework** | SwiftUI | Reactive views, declarative hierarchy, spring animations |
| **Charting** | Swift Charts (`Charts`) | `LineMark`, `AreaMark`, `PointMark`, custom axis values & mark styles |
| **Mapping** | MapKit (`MapKit`) & `CoreLocation` | Interactive camera position, `MapCircle`, custom tap-gesture annotations |
| **Machine Learning**| Core ML (`CoreML`) | On-device model initialization and zero-latency inference |
| **Testing** | XCTest & XCUITest | Unit test suites, performance measurements, and UI automation tests |

---

## Getting Started

### Prerequisites
- **Mac** running macOS Sonoma (14.0+) or macOS Sequoia (15.0+).
- **Xcode** 15.0 or later installed.
- **iOS Simulator** or physical device running **iOS 17.0+**.

### Build and Run
1. **Clone or Navigate to the Repository**:
   ```bash
   cd /path/to/myUnicorn
   ```
2. **Open the Project in Xcode**:
   ```bash
   open myUnicorn.xcodeproj
   ```
3. **Select a Target & Destination**:
   - In Xcode's toolbar, choose the scheme `myUnicorn`.
   - Select an iOS Simulator (e.g., *iPhone 16 Pro* or *iPhone 15*).
4. **Compile and Run**:
   - Press **`Cmd + R`** or click the **Play** button in Xcode.
   - Navigate through the onboarding screen to access the Dashboard and AI Predictor.

### Running Tests
- Press **`Cmd + U`** to execute the unit and UI test suites.

---

## License & Attribution

Developed as part of the **CS192-4P** project curriculum.  
All sample unicorn benchmark figures are compiled for educational and analytical purposes.  
