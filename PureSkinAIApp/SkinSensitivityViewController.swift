import UIKit

class SkinSensitivityViewController: UIViewController {
    
    // MARK: - Properties
    var isEditingMode: Bool = false
    private var selectedSensitivity: SkinSensitivity?
    
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
        label.text = "Cilt Hassasiyetiniz"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Bu bilgi sana özel tavsiyeler vermemizde yardımcı olacak."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sensitivityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let detailView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0.1)
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Devam Et", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0.5
        button.isEnabled = false
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
        view.backgroundColor = .systemGray6
        title = isEditingMode ? "Cilt Hassasiyetini Düzenle" : "Cilt Hassasiyeti"
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        if isEditingMode {
            loadExistingData()
        } else {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        setupUI()
    }
    
    private func loadExistingData() {
        if let sensitivityRawValue = UserDefaults.standard.object(forKey: "userSkinSensitivity") as? Int {
            selectedSensitivity = SkinSensitivity(rawValue: sensitivityRawValue)
            updateSensitivityButtonSelection()
        }
        
        checkContinueButtonState()
    }
    
    private func updateSensitivityButtonSelection() {
        guard let selectedSensitivity = selectedSensitivity else { return }
        
        sensitivityStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton, button.tag == selectedSensitivity.rawValue {
                sensitivityButtonTapped(button)
            }
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(sensitivityStackView)
        contentView.addSubview(detailView)
        detailView.addSubview(detailLabel)
        view.addSubview(continueButton)
        view.addSubview(backButton)
        
        setupSensitivityOptions()
        
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
            
            sensitivityStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            sensitivityStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sensitivityStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            detailView.topAnchor.constraint(equalTo: sensitivityStackView.bottomAnchor, constant: 20),
            detailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            detailLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 15),
            detailLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 15),
            detailLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -15),
            detailLabel.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -15),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func setupSensitivityOptions() {
        let sensitivities: [(title: String, icon: String, description: String, type: SkinSensitivity)] = [
            ("Hiç hassas değil", "face1", "Cildiniz güçlü ve dayanıklı.", .notSensitive),
            ("Biraz hassas", "face2", "Cildiniz zaman zaman hassasiyet gösterebilir.", .slightlySensitive),
            ("Çok hassas", "face3", "Cildiniz sık sık hassasiyet gösterir.", .verySensitive)
        ]
        
        for (title, icon, description, type) in sensitivities {
            let button = createSensitivityButton(title: title, description: description, icon: icon, sensitivity: type)
            sensitivityStackView.addArrangedSubview(button)
        }
    }
    
    private func createSensitivityButton(title: String, description: String, icon: String, sensitivity: SkinSensitivity) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        button.tag = sensitivity.rawValue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // İçerik stack view
        let contentStack = UIStackView()
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 15
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.isUserInteractionEnabled = false
        
        // İkon
        let imageView = UIImageView()
        imageView.image = UIImage(named: icon)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        
        // Metin stack view
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 5
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.isUserInteractionEnabled = false
        
        // Başlık
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.isUserInteractionEnabled = false
        
        // Açıklama
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.isUserInteractionEnabled = false
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        
        contentStack.addArrangedSubview(imageView)
        contentStack.addArrangedSubview(textStack)
        
        button.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: button.topAnchor, constant: 15),
            contentStack.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 15),
            contentStack.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -15),
            contentStack.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -15),
            
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        button.addTarget(self, action: #selector(sensitivityButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    // MARK: - Actions
    @objc private func sensitivityButtonTapped(_ sender: UIButton) {
       
        sensitivityStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton {
                button.backgroundColor = .white
                button.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
                
               
                if let contentStack = button.subviews.first as? UIStackView {
                   
                    if let titleLabel = contentStack.arrangedSubviews.first as? UILabel {
                        titleLabel.textColor = .black
                    }
                    if let descriptionLabel = contentStack.arrangedSubviews.last as? UILabel {
                        descriptionLabel.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
                    }
                }
            }
        }
        
        sender.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0.1)
        sender.layer.borderColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0).cgColor
        
        if let contentStack = sender.subviews.first as? UIStackView {
    
            if let titleLabel = contentStack.arrangedSubviews.first as? UILabel {
                titleLabel.textColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
            }
            
          
        }
        
        selectedSensitivity = SkinSensitivity(rawValue: sender.tag)
        checkContinueButtonState()
    }
    
    private func checkContinueButtonState() {
        if selectedSensitivity != nil {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc private func continueButtonTapped() {
      
        if let sensitivity = selectedSensitivity {
            UserDefaults.standard.set(sensitivity.rawValue, forKey: "userSkinSensitivity")
        }
        
        let skinProblemsVC = SkinProblemsViewController()
        navigationController?.pushViewController(skinProblemsVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

