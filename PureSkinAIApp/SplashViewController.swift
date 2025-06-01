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
        // 2 saniye sonra yönlendirme yap
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.checkUserDataAndNavigate()
        }
    }
    
    // MARK: - Setup
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
    
    // MARK: - Navigation
    private func checkUserDataAndNavigate() {
        // Kullanıcı verilerini kontrol et
        if UserDefaults.standard.object(forKey: "userGender") != nil &&
           UserDefaults.standard.object(forKey: "userAgeRange") != nil &&
           UserDefaults.standard.object(forKey: "userSkinType") != nil {
            // Veri varsa ana sayfaya yönlendir
            navigateToMainScreen()
        } else {
            // Veri yoksa onboarding ekranlarına yönlendir
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
    
    private func navigateToMainScreen() {
        // Navigation bar görünümü
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        // Tab bar controller oluştur
        let tabBarController = UITabBarController()
        
        // Ürünler
        let productsVC = ProductsViewController()
        let productsNav = UINavigationController(rootViewController: productsVC)
        productsNav.navigationBar.standardAppearance = appearance
        productsNav.navigationBar.scrollEdgeAppearance = appearance
        productsNav.navigationBar.prefersLargeTitles = false
        productsNav.navigationBar.isTranslucent = false
        productsNav.tabBarItem = UITabBarItem(title: "Ürünler", image: UIImage(systemName: "sparkles"), tag: 0)
        
        // Rutinler
        let routinesVC = RoutinesViewController()
        let routinesNav = UINavigationController(rootViewController: routinesVC)
        routinesNav.navigationBar.standardAppearance = appearance
        routinesNav.navigationBar.scrollEdgeAppearance = appearance
        routinesNav.navigationBar.prefersLargeTitles = false
        routinesNav.navigationBar.isTranslucent = false
        routinesNav.tabBarItem = UITabBarItem(title: "Rutinler", image: UIImage(systemName: "calendar"), tag: 1)
        
        // Sohbet
        let chatVC = ChatViewController()
        let chatNav = UINavigationController(rootViewController: chatVC)
        chatNav.navigationBar.standardAppearance = appearance
        chatNav.navigationBar.scrollEdgeAppearance = appearance
        chatNav.navigationBar.prefersLargeTitles = false
        chatNav.navigationBar.isTranslucent = false
        chatNav.tabBarItem = UITabBarItem(title: "Sohbet", image: UIImage(systemName: "message.fill"), tag: 2)
        
        // Profil
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.navigationBar.standardAppearance = appearance
        profileNav.navigationBar.scrollEdgeAppearance = appearance
        profileNav.navigationBar.prefersLargeTitles = false
        profileNav.navigationBar.isTranslucent = false
        profileNav.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person.fill"), tag: 3)
        
        // Tab bar controller ayarları
        tabBarController.viewControllers = [productsNav, routinesNav, chatNav, profileNav]
        tabBarController.tabBar.tintColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        tabBarController.tabBar.unselectedItemTintColor = .gray
        
        // Tab bar controller'ı root view controller olarak ayarla
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tabBarController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
} 
