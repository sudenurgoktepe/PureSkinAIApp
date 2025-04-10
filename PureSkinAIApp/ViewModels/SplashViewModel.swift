import UIKit

class SplashViewModel {
    // Splash tamamlandığında çağrılacak closure
    var onSplashCompleted: (() -> Void)?
    
    // Splash ekranı için zamanlayıcı
    func startSplashTimer() {
        // 2 saniye sonra onSplashCompleted closure'ını çağır
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.onSplashCompleted?()
        }
    }
} 