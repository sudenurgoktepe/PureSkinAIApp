import UIKit

class OnboardingViewModel {
    // Ana ekrana geçiş için closure
    var onStartButtonTapped: (() -> Void)?
    
    // Yıldız animasyonu için gecikme hesaplama
    func delayForStarIndex(_ index: Int) -> Double {
        return 1.0 + Double(index) * 0.2
    }
} 
