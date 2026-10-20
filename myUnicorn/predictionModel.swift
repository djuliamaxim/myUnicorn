import Foundation
import CoreML

class PredictionService {
    static let shared = PredictionService()
    
    // 1. Initialize the model ONCE as a property to save memory and battery
    private let model: FinalUnicornPredictor?
    
    private init() {
        do {
            let config = MLModelConfiguration()
            self.model = try FinalUnicornPredictor(configuration: config)
        } catch {
            print("Failed to load Core ML model: \(error.localizedDescription)")
            self.model = nil
        }
    }
    
    struct PredictionResult {
        let tier: String
        let confidence: Double
    }
    
    // 2. Added `dealTerms` to match the 5 features from the Python training data
    func predictTier(foundedYear: Double, totalRaised: Double, investorsCount: Double, dealTerms: Double, yearsToUnicorn: Double) -> PredictionResult? {
        
        // Ensure the model loaded successfully during init
        guard let model = model else {
            print("Model is not initialized.")
            return nil
        }
        
        do {
            // 3. Use the auto-generated "Input" struct/class from Xcode
            let input = FinalUnicornPredictorInput(
                Founded_Year: foundedYear,
                Total_Raised: totalRaised,
                Investors_Count: investorsCount,
                Deal_Terms: dealTerms,
                Years_To_Unicorn: yearsToUnicorn
            )
            
            let output = try model.prediction(input: input)
            let predictedTier = output.Tier
            
            // Note: If Xcode throws an error on `classProbability`,
            // it means the Python export did not explicitly map probabilities.
            // You can safely remove this line and just return the Tier if that happens.
            let confidence = output.classProbability[predictedTier] ?? 0.0
            
            return PredictionResult(tier: predictedTier, confidence: confidence)
            
        } catch {
            print("Core ML Inference evaluation pass error encountered: \(error.localizedDescription)")
            return nil
        }
    }
}
