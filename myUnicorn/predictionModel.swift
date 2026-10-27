import Foundation
import CoreML

class PredictionService {
    static let shared = PredictionService()
    
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
    
    func predictTier(foundedYear: Double, totalRaised: Double, investorsCount: Double, dealTerms: Double, yearsToUnicorn: Double) -> PredictionResult? {
        

        guard let model = model else {
            print("Model is not initialized.")
            return nil
        }
        
        do {

            let input = FinalUnicornPredictorInput(
                Founded_Year: foundedYear,
                Total_Raised: totalRaised,
                Investors_Count: investorsCount,
                Deal_Terms: dealTerms,
                Years_To_Unicorn: yearsToUnicorn
            )
            
            let output = try model.prediction(input: input)
            let predictedTier = output.Tier
            let confidence = output.classProbability[predictedTier] ?? 0.0
            
            return PredictionResult(tier: predictedTier, confidence: confidence)
            
        } catch {
            print("Core ML Inference evaluation pass error encountered: \(error.localizedDescription)")
            return nil
        }
    }
}
