import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = SplashViewModel()
    
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
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startSplashTimer()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Açık yeşil arka plan
        view.backgroundColor = UIColor(red: 200/255, green: 230/255, blue: 200/255, alpha: 1.0)
        
        // İkon ekleme
        view.addSubview(iconImageView)
        
        // Constraint'ler
        NSLayoutConstraint.activate([
            // İkon ortalama
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 150),
            iconImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        viewModel.onSplashCompleted = { [weak self] in
            guard let self = self else { return }
            
            // Onboarding ekranına geçiş
            let onboardingVC = OnboardingViewController()
            onboardingVC.modalPresentationStyle = .fullScreen
            self.present(onboardingVC, animated: true)
        }
    }
} 