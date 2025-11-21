import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "faceicon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.checkUserDataAndNavigate()
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 200/255, green: 230/255, blue: 200/255, alpha: 1.0)
        
        view.addSubview(iconImageView)
    
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 150),
            iconImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    // MARK: - Navigation
    private func checkUserDataAndNavigate() {
        if UserDefaults.standard.object(forKey: "userGender") != nil &&
            UserDefaults.standard.object(forKey: "userAgeRange") != nil &&
            UserDefaults.standard.object(forKey: "userSkinType") != nil {
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = CustomTabBarController()
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
            
        } else {
            navigateToOnboarding()
        }
    }
    
    private func navigateToOnboarding() {
        let onboardingVC = OnboardingViewController()
        let navController = UINavigationController(rootViewController: onboardingVC)
        navController.setNavigationBarHidden(true, animated: false)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
} 
