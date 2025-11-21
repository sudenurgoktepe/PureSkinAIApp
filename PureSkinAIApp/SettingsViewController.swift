import UIKit

class SettingsViewController: UIViewController {
    
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
    
    private let deleteAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hesabımı Sil", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .labelPrimary
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundcolor
        title = "Ayarlar"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(deleteAccountButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            deleteAccountButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            deleteAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deleteAccountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 50),
            deleteAccountButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
    }
    
    @objc private func deleteAccountButtonTapped() {
        let alert = UIAlertController(
            title: "Hesabı Sil",
            message: "Hesabınız kalıcı olarak silinecek. Bu işlem geri alınamaz. Devam etmek istiyor musunuz?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
        let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { [weak self] _ in
            self?.deleteAccount()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
    private func deleteAccount() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
        defaults.set(false, forKey: "hasUserData")
        
        let onboardingVC = OnboardingViewController()
        let navigationController = UINavigationController(rootViewController: onboardingVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            
            UIView.transition(with: window,
                            duration: 0.3,
                            options: .transitionCrossDissolve,
                            animations: nil,
                            completion: nil)
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
} 
