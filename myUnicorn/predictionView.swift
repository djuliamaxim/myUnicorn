import SwiftUI

struct PredictorView: View {
    @State private var foundedYear: Double = 2015
    @State private var totalRaised: Double = 250_000_000
    @State private var investorsCount: Double = 10
    @State private var yearsToUnicorn: Double = 5
    
    @State private var predictedTier: String = "Ready"
    @State private var confidenceScore: Double = 0.0
    @State private var hasPrediction = false
    @State private var dealTerms: Double = 3

    private var dealTermsText: String {
        String(format: "%.0f", dealTerms)
    }
    
    private var foundedYearText: String {
        String(format: "%.0f", foundedYear)
    }
    
    private var totalRaisedText: String {
        totalRaised.formatted(.currency(code: "USD").notation(.compactName))
    }
    
    private var investorsText: String {
        String(format: "%.0f", investorsCount)
    }
    
    private var yearsToUnicornText: String {
        String(format: "%.0f years", yearsToUnicorn)
    }
    
    private var confidencePercent: String {
        hasPrediction ? String(format: "%.1f%%", confidenceScore * 100) : "--"
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                header
                resultCard
                inputCard
                evaluateButton
                insightFooter
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        //.navigationTitle("AI Predictor")
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("AI Tier Predictor")
                .font(.title2.weight(.bold))
            
            Text("Estimate a unicorn's value tier from core company signals")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var resultCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Prediction Result")
                        .font(.headline)
                    Text(hasPrediction ? "Latest Core ML output" : "Run the model to generate a tier")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(confidencePercent)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.purple)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.purple.opacity(0.12), in: Capsule())
            }
            
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.14))
                        .frame(width: 56, height: 56)
                    Image(systemName: hasPrediction ? "sparkles" : "brain.head.profile")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.purple)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(predictedTier)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(hasPrediction ? tierColor : .secondary)
                    Text(resultDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            
            confidenceBar
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private var confidenceBar: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Model confidence")
                Spacer()
                Text(confidencePercent)
                    .monospacedDigit()
            }
            .font(.caption.weight(.medium))
            .foregroundStyle(.secondary)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.tertiarySystemFill))
                    Capsule()
                        .fill(Color.purple)
                        .frame(width: hasPrediction ? geometry.size.width * confidenceScore : 0)
                }
            }
            .frame(height: 10)
        }
    }
    
    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Company Inputs")
                    .font(.headline)
                Text("Adjust the profile before running inference")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            inputSlider(
                title: "Founded Year",
                valueText: foundedYearText,
                systemImage: "calendar",
                value: $foundedYear,
                range: 2000...2026,
                step: 1
            )
            
            inputSlider(
                title: "Total Raised",
                valueText: totalRaisedText,
                systemImage: "dollarsign.circle",
                value: $totalRaised,
                range: 1_000_000...5_000_000_000,
                step: 10_000_000
            )
            
            inputSlider(
                title: "Investors",
                valueText: investorsText,
                systemImage: "person.3.fill",
                value: $investorsCount,
                range: 1...80,
                step: 1
            )
            
            inputSlider(
                title: "Deal Terms",
                valueText: dealTermsText,
                systemImage: "doc.text.fill", // or "doc.text.fill"
                value: $dealTerms,
                range: 1...20,
                step: 1
            )
            
            inputSlider(
                title: "Years to Unicorn",
                valueText: yearsToUnicornText,
                systemImage: "timer",
                value: $yearsToUnicorn,
                range: 1...25,
                step: 1
            )
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private var evaluateButton: some View {
        Button(action: runInferenceInversionPass) {
            HStack(spacing: 10) {
                Image(systemName: "cpu.fill")
                Text("Evaluate with Core ML")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(.white)
            .background(Color.purple.gradient, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: Color.purple.opacity(0.22), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
    
    private var insightFooter: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(.secondary)
            
            Text("Predictions are generated on-device from the bundled Core ML classifier using funding, investor count, founding year, and speed to unicorn status.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 4)
    }
    
    private var tierColor: Color {
        switch predictedTier {
        case "High":
            return .purple
        case "Low":
            return .secondary
        default:
            return .primary
        }
    }
    
    private var resultDescription: String {
        guard hasPrediction else { return "Waiting for company metrics" }
        return "Estimated value tier category"
    }
    
    private func inputSlider(
        title: String,
        valueText: String,
        systemImage: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.purple)
                    .frame(width: 26, height: 26)
                    .background(Color.purple.opacity(0.12), in: Circle())
                
                Text(title)
                    .font(.subheadline.weight(.semibold))
                
                Spacer()
                
                Text(valueText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.purple)
                    .monospacedDigit()
            }
            
            Slider(value: value, in: range, step: step)
                .tint(.purple)
        }
    }
    
    private func runInferenceInversionPass() {
        if let output = PredictionService.shared.predictTier(
            foundedYear: foundedYear,
            totalRaised: totalRaised,
            investorsCount: investorsCount,
            dealTerms: dealTerms,  
            yearsToUnicorn: yearsToUnicorn
        ) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                predictedTier = output.tier
                confidenceScore = output.confidence
                hasPrediction = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        PredictorView()
    }
}
