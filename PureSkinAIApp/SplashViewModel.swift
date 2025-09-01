import UIKit

class SplashViewModel {
    var onSplashCompleted: (() -> Void)?
    
    func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.onSplashCompleted?()
        }
    }
} 
