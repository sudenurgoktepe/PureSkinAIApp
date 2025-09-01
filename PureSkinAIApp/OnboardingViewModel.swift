import UIKit

class OnboardingViewModel {
    var onStartButtonTapped: (() -> Void)?
    
    func delayForStarIndex(_ index: Int) -> Double {
        return 1.0 + Double(index) * 0.2
    }
} 
