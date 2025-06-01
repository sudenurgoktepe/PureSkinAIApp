import UIKit

class SkinAnalysisViewController: UIViewController {
    
    // MARK: - Properties
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
        imageView.image = UIImage(named: "onboardingimage6")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.7
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cilt Analiziniz Devam Ediyor!"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Verdiğiniz bilgilere göre kişiye özel cilt bakım rutininizi oluşturmaya hazırız."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let analysisStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hadi Başlayalım!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(analysisStackView)
        view.addSubview(continueButton)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
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
            headerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            titleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            analysisStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            analysisStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            analysisStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            analysisStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        // Analiz animasyonunu başlat
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.startAnalysisAnimation()
        }
    }
    
    private func createAnalysisRow(text: String, isLastRow: Bool = false) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let checkmarkImageView = UIImageView()
        let checkmarkConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let checkmarkImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: checkmarkConfig)
        checkmarkImageView.image = checkmarkImage
        checkmarkImageView.tintColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        checkmarkImageView.alpha = 0
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        
        if isLastRow {
            let attributedText = NSMutableAttributedString(string: text)
            let greenColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
            
            // "16" yazısını yeşil yap
            if let range = text.range(of: "16") {
                let nsRange = NSRange(range, in: text)
                attributedText.addAttribute(.foregroundColor, value: greenColor, range: nsRange)
                attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: nsRange)
            }
            
            // 3 basamaklı sayıyı yeşil yap
            let numberPattern = "\\d{3}"
            if let regex = try? NSRegularExpression(pattern: numberPattern, options: []) {
                let matches = regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
                for match in matches {
                    attributedText.addAttribute(.foregroundColor, value: greenColor, range: match.range)
                    attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: match.range)
                }
            }
            
            label.attributedText = attributedText
            label.font = UIFont.systemFont(ofSize: 14)
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.8
        }
        
        stackView.addArrangedSubview(checkmarkImageView)
        stackView.addArrangedSubview(label)
        
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return containerView
    }
    
    private func startAnalysisAnimation() {
        let analysisTexts = [
            "Cilt sorunlarınız analiz edildi",
            "İçerik tercihlerin kaydedildi",
            "Güvenli içerikler belirlendi",
            "Kişiye özel ürün önerilerin hazır",
            "Senin için 16 ürün hazırladık ve günlere özenle yerleştirdik. Ayrıca rutinlerinde kullanabileceğin \(Int.random(in: 100...999)) ürün tespit ettik."
        ]
        
        for (index, text) in analysisTexts.enumerated() {
            let row = createAnalysisRow(text: text, isLastRow: index == analysisTexts.count - 1)
            row.alpha = 0
            row.transform = CGAffineTransform(translationX: -50, y: 0)
            analysisStackView.addArrangedSubview(row)
            
            UIView.animate(withDuration: 0.5, delay: Double(index) * 2.0, options: .curveEaseOut, animations: {
                row.alpha = 1
                row.transform = .identity
            }) { _ in
                if let checkmark = row.subviews.first?.subviews.first as? UIImageView {
                    UIView.animate(withDuration: 0.3) {
                        checkmark.alpha = 1
                    }
                }
                
                if index == analysisTexts.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        UIView.animate(withDuration: 0.5) {
                            self.continueButton.alpha = 1
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func continueButtonTapped() {
        navigateToMainScreen()
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
