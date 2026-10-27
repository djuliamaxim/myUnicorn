# myUnicorn AI 🦄 (https://github.com/djuliamaxim/myUnicorn/App_showcase.gif)

[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple.svg)](https://developer.apple.com/xcode/swiftui/)
[![CoreML](https://img.shields.io/badge/ML-Core%20ML-green.svg)](https://developer.apple.com/documentation/coreml)
[![Swift Charts](https://img.shields.io/badge/Visualizations-Swift%20Charts%20%7C%20MapKit-indigo.svg)](https://developer.apple.com/documentation/charts)

**myUnicorn AI** is a native iOS application for exploring, visualizing, and predicting valuation dynamics across global billion-dollar private startups ("unicorns"). It combines interactive exploratory data analysis with a custom-trained, on-device machine learning model, delivering industry insights, geospatial clustering, funding-to-valuation correlations, and on-demand valuation tier predictions.

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Machine Learning](#machine-learning)
- [Project Structure](#project-structure)
- [Data](#data)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [License & Attribution](#license--attribution)

---

## Overview

In venture capital and tech ecosystems, a **unicorn** is a privately held startup valued at **$1 billion or more**. As startup valuations have grown rapidly over the past decade, understanding growth trends, industry leadership, capital efficiency, and geographic distribution has become increasingly important.

**myUnicorn** addresses this by:
1. Turning global startup datasets into **five interactive visualization views** built with Apple's **Swift Charts** and **MapKit**.
2. Running a **Random Forest classifier** that I trained on startup data and bundled as a Core ML model (`FinalUnicornPredictor.mlmodel`). It predicts whether a startup falls in a **High** or **Low** valuation tier from five funding and operational inputs, entirely on-device with no server calls.

---

## Key Features

### 1. Onboarding & Dashboard
- **Welcome screen** ([`ContentView.swift`](myUnicorn/ContentView.swift)): introduces unicorn fundamentals, highlights the app's capabilities (Charts, Maps, AI Model), and leads into the main dashboard with a spring animation.
- **Dashboard** ([`chartScreen.swift`](myUnicorn/chartScreen.swift)): card-based navigation to each chart module, with SF Symbols and grouped styling.
- **Tab navigation** ([`MainTabView.swift`](myUnicorn/MainTabView.swift)): switches between the **Summary** dashboard and the **AI Predictor**.

### 2. Analytical Visualizations

| Module | File | Framework | Key Capabilities |
| :--- | :--- | :--- | :--- |
| **Global Explosion** | [`lineGraph.swift`](myUnicorn/Charts/lineGraph.swift) | `Charts` | Cumulative growth curve (2011–2022) with smoothed `AreaMark`, `LineMark`, and annotated `PointMark` milestones, including the 2021 surge (+466 unicorns). |
| **Industries** | [`barGraph.swift`](myUnicorn/Charts/barGraph.swift) | `SwiftUI` | Ranked horizontal bar chart of 15 startup sectors with KPI tiles. Fintech (189 companies) and Internet Software (179) together account for about 41% of all unicorns. |
| **Market Share** | [`treeMap.swift`](myUnicorn/Charts/treeMap.swift) | `SwiftUI` | Custom proportional treemap of valuation by country, led by the United States ($1.93T, 61% share), followed by China, the UK, and India. |
| **Correlations** | [`scatterpointChart.swift`](myUnicorn/Charts/scatterpointChart.swift) | `Charts` | Scatter plot of capital raised ($B) against valuation ($B) for companies such as ByteDance, SpaceX, Stripe, and Klarna, with industry color-coding and trend insights. |
| **Global Hubs** | [`geospatialMap.swift`](myUnicorn/Charts/geospatialMap.swift) | `MapKit` | World map of startup hubs (San Francisco, New York, Beijing, Shanghai, London, Bengaluru, Shenzhen) using proportional `MapCircle` radii and tap-to-inspect overlays. |

### 3. On-Device Valuation Predictor
Implemented in [`predictionView.swift`](myUnicorn/predictionView.swift) and [`predictionModel.swift`](myUnicorn/predictionModel.swift):
- **Interactive sliders** for the five model inputs, with formatted displays (compact USD, years, elapsed intervals).
- **Core ML inference** through `PredictionService.shared`.
- **Result card** showing the predicted tier badge (`High` or `Low`), a short interpretation, and an animated confidence bar.
- **Privacy-first:** no data leaves the device, and inference runs locally through Core ML.

---

## Machine Learning

The app bundles **`FinalUnicornPredictor.mlmodel`**, a Random Forest classifier trained in Python (Google Colab) on startup data.

### Model Selection

I compared four candidate models on a 70/30 train/test split:

| Model | Accuracy |
| :--- | :---: |
| Decision Tree (Gini) | 67.58% |
| Decision Tree (Entropy) | 67.58% |
| **Random Forest (50 trees)** | **73.05%** |
| Random Forest (100 trees) | 71.88% |

**Random Forest (50 trees)** performed best and was selected as the final model.

### Final Evaluation

To estimate real-world performance, the selected model was evaluated on a separate **10% hold-out set** that was kept aside from the start and never used for model selection:

| Evaluation | Accuracy |
| :--- | :---: |
| Hold-out set (10%) | **71.58%** |

The model is a two-class classifier (High vs. Low tier), so the roughly 72% hold-out accuracy should be read as a useful screening signal, not a precise valuation estimate.

### Input Features

| Feature | Swift Type | Model Input Key | Range | Default | Unit / Format |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Founded Year** | `Double` | `Founded_Year` | `2000 – 2026` | `2015` | Year (`YYYY`) |
| **Total Raised** | `Double` | `Total_Raised` | `$1M – $5B` | `$250M` | USD (`$10M` step) |
| **Investors Count** | `Double` | `Investors_Count` | `1 – 80` | `10` | Number of investors |
| **Deal Terms** | `Double` | `Deal_Terms` | `1 – 20` | `3` | Funding rounds and terms count |
| **Years to Unicorn** | `Double` | `Years_To_Unicorn` | `1 – 25` | `5` | Years from founding to $1B |

### Output

| Feature | Type | Description |
| :--- | :--- | :--- |
| **Tier** | `String` | Predicted class: **`High`** (upper valuation tier) or **`Low`** (base valuation tier). |
| **classProbability** | `[String: Double]` | Class probabilities that [`predictionModel.swift`](myUnicorn/predictionModel.swift) uses to display the confidence score (0%–100%). |

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

## Project Structure

```text
myUnicorn/
├── myUnicorn.xcodeproj                 # Xcode project configuration
├── FinalUnicornPredictor.mlmodel       # Bundled Core ML classification model
└── myUnicorn/
    ├── myUnicornApp.swift              # App entry point (@main)
    ├── ContentView.swift               # Welcome / onboarding screen
    ├── MainTabView.swift               # Tab navigation
    ├── chartScreen.swift               # Dashboard with links to each chart
    ├── Item.swift                      # Data models and Identifiable structs
    ├── myData.swift                    # Sample datasets and hub constants
    ├── predictionModel.swift           # PredictionService singleton for Core ML inference
    ├── predictionView.swift            # Prediction UI with sliders and result card
    ├── Charts/
    │   ├── barGraph.swift              # Industry distribution bar chart
    │   ├── geospatialMap.swift         # MapKit density map
    │   ├── lineGraph.swift             # Cumulative growth timeline
    │   ├── scatterpointChart.swift     # Capital raised vs. valuation scatter plot
    │   └── treeMap.swift               # Country valuation treemap
    └── Assets.xcassets                 # App icons, accent colors, assets
```

### Architectural Principles

- **Declarative SwiftUI:** state (`@State`, `@Binding`) is kept separate from presentation logic.
- **Service singleton:** [`PredictionService`](myUnicorn/predictionModel.swift) loads `FinalUnicornPredictor` once for the app's lifetime to save memory and battery.
- **Adaptive appearance:** semantic system colors (e.g. `Color(.secondarySystemGroupedBackground)`) support Light and Dark Mode without hardcoded colors.
- **Modular visualizations:** each chart view is self-contained, with its own summary tiles, axis formatting, and insight footer.

---

## Data

Structured datasets live in [`myData.swift`](myUnicorn/myData.swift), with models defined in [`Item.swift`](myUnicorn/Item.swift):

- **Industry distribution** (`IndustryDistribution`): 946+ companies across 15 sectors (Fintech, Internet Software, AI, E-commerce, Health, Supply Chain, Cybersecurity, and more).
- **Timeline growth** (`GrowthTimeline`): annual cumulative counts, from 2 unicorns in 2011 to nearly 1,000 in 2022.
- **Country valuation treemap** (`CountryValueNode`): country-level valuations led by the United States ($1.93T), China ($569B), the United Kingdom ($150B), and India ($148B).
- **Tech hub clusters** (`TechHubLocation`): GPS coordinates (`CLLocationCoordinate2D`), unicorn counts, and cumulative valuations for top startup cities.
- **Venture scatter points** (`CompanyScatterPoint`): total funding raised vs. current valuation.

---

## Tech Stack

| Layer | Technology | Usage |
| :--- | :--- | :--- |
| **Language** | Swift 5.9+ | Type-safe, modern Swift |
| **UI** | SwiftUI | Declarative views, spring animations |
| **Charting** | Swift Charts | `LineMark`, `AreaMark`, `PointMark`, custom axes and mark styles |
| **Mapping** | MapKit, CoreLocation | Interactive camera, `MapCircle`, tap-gesture annotations |
| **Machine Learning** | Core ML | On-device model loading and inference |
| **Model Training** | Python (Google Colab) | Decision Tree and Random Forest experiments, model selection, hold-out evaluation |

---

## Getting Started

### Prerequisites
- A Mac running macOS Sonoma (14.0+) or later
- Xcode 15.0 or later
- An iOS Simulator or physical device running iOS 17.0+

### Build and Run
1. **Open the project:**
   ```bash
   cd /path/to/myUnicorn
   open myUnicorn.xcodeproj
   ```
2. **Select the `myUnicorn` scheme** and an iOS Simulator (e.g. iPhone 16 Pro).
3. **Press `Cmd + R`** to build and run, then use the welcome screen to reach the dashboard and AI Predictor.

---

## License & Attribution

Developed as part of the **CS192-4P** project curriculum.
All sample unicorn figures are compiled for educational and analytical purposes.
