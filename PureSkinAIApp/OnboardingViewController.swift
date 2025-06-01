import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = OnboardingViewModel()
    private var starImageViews = [UIImageView]()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "onboardingimage3")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        
        // Gölge efekti için container view
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 8
        containerView.addSubview(imageView)
        
        return imageView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let text = "PureSkinAI'e"
        let attributedText = NSMutableAttributedString(string: text)
        
        // PureSkinAI kısmını yeşil yap
        if let range = text.range(of: "PureSkinAI") {
            let nsRange = NSRange(range, in: text)
            attributedText.addAttribute(.foregroundColor, value: UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0), range: nsRange)
        }
        
        // 'e' kısmını siyah yap
        if let range = text.range(of: "'e") {
            let nsRange = NSRange(range, in: text)
            attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
        }
        
        label.attributedText = attributedText
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "Hoşgeldiniz"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Işıltılı, sağlıklı ve parlak bir cilt için nihai cilt bakım arkadaşınız! Kişiye özel rutinler, uzman ipuçları ve cilt bakım yolculuğunuzu dönüştürmek için tasarlanmış yenilikçi araçları keşfedin."
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0) // Soft gri
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    private let starsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hadi Başlayalım", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0) // PureSkinAI yeşili
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupUI()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateElements()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerImageView)
        contentView.addSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleLabel2)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(starsStackView)
        view.addSubview(continueButton)
        
        setupStars()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            titleStackView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 30),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            starsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            starsStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        continueButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    private func setupStars() {
        // 5 adet yıldız oluşturma
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(systemName: "star.fill")
            starImageView.tintColor = UIColor.systemYellow
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.alpha = 0
            
            starsStackView.addArrangedSubview(starImageView)
            
            // Yıldız boyutu
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 30),
                starImageView.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            starImageViews.append(starImageView)
        }
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        viewModel.onStartButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            // Ana ekrana geçiş
            navigateToMainScreen()
        }
    }
    
    // MARK: - Animations
    private func animateElements() {
        // Üst görsel animasyonu
        UIView.animate(withDuration: 0.8, delay: 0.2, options: .curveEaseOut) {
            self.headerImageView.alpha = 1
            self.headerImageView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        // Başlık animasyonları
        UIView.animate(withDuration: 0.8, delay: 0.4, options: .curveEaseOut) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.6, options: .curveEaseOut) {
            self.titleLabel2.alpha = 1
            self.titleLabel2.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        // Açıklama animasyonu
        UIView.animate(withDuration: 0.8, delay: 0.8, options: .curveEaseOut) {
            self.descriptionLabel.alpha = 1
            self.descriptionLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        // Yıldız animasyonları
        for (index, starView) in self.starImageViews.enumerated() {
            let delay = viewModel.delayForStarIndex(index)
            
            UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseIn) {
                starView.alpha = 1
                starView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        
        // Buton animasyonu
        UIView.animate(withDuration: 0.8, delay: 2.0, options: .curveEaseOut) {
            self.continueButton.alpha = 1
            self.continueButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    // MARK: - Actions
    @objc private func startButtonTapped() {
        let userInfoVC = UserInfoViewController()
        navigationController?.pushViewController(userInfoVC, animated: true)
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
