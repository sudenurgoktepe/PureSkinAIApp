import UIKit

class SkinTypeViewController: UIViewController {
    
    // MARK: - Properties
    var isEditingMode: Bool = false
    private var selectedSkinType: SkinType?
    
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
        imageView.image = UIImage(named: "onboardingimage2")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.7
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cilt Tipiniz"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Mükemmel cilt bakım rutini oluşturabilmemiz için cilt tipinizi seçin"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0) // Solgun gri
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skinTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Devam Et", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0) // PureSkinAI yeşili
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
        title = isEditingMode ? "Cilt Tipini Düzenle" : "Cilt Tipi"
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        if isEditingMode {
            loadExistingData()
        } else {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        setupUI()
    }
    
    private func loadExistingData() {
        if let skinTypeRawValue = UserDefaults.standard.object(forKey: "userSkinType") as? Int {
            selectedSkinType = SkinType(rawValue: skinTypeRawValue)
            updateSkinTypeButtonSelection()
        }
        
        checkContinueButtonState()
    }
    
    private func updateSkinTypeButtonSelection() {
        guard let selectedSkinType = selectedSkinType else { return }
        
        skinTypeStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton, button.tag == selectedSkinType.rawValue {
                skinTypeButtonTapped(button)
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
        contentView.addSubview(skinTypeStackView)
        view.addSubview(continueButton)
        view.addSubview(backButton)
        
        setupSkinTypeOptions()
        
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
            
            skinTypeStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            skinTypeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            skinTypeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            skinTypeStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func setupSkinTypeOptions() {
        let skinTypes: [(title: String, description: String, icon: String, type: SkinType)] = [
            ("Normal Cilt", "Dengeli ve sağlıklı görünümlü cilt", "normalskin", .normal),
            ("Kuru Cilt", "Pullanan ve hassas cilt", "dryskin", .dry),
            ("Yağlı Cilt", "Parlak ve gözenekli cilt", "oilyskin", .oily),
            ("Karma Cilt", "Bölgesel farklılıklar gösteren cilt", "combinationskin", .combination)
        ]
        
        for (title, description, icon, type) in skinTypes {
            let button = createSkinTypeButton(title: title, description: description, icon: icon, type: type)
            skinTypeStackView.addArrangedSubview(button)
        }
    }
    
    private func createSkinTypeButton(title: String, description: String, icon: String, type: SkinType) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        button.tag = type.rawValue
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
        
        button.addTarget(self, action: #selector(skinTypeButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    // MARK: - Actions
    @objc private func skinTypeButtonTapped(_ sender: UIButton) {
        // Önceki seçimi temizle
        skinTypeStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton {
                button.backgroundColor = .white
                button.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
                
                // İçerik stack view'ı bul
                if let contentStack = button.subviews.first as? UIStackView {
                    // Başlık rengini sıfırla
                    if let titleLabel = contentStack.arrangedSubviews.first as? UILabel {
                        titleLabel.textColor = .black
                    }
                    
                    // Açıklama rengini sıfırla
                    if let descriptionLabel = contentStack.arrangedSubviews.last as? UILabel {
                        descriptionLabel.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
                    }
                }
            }
        }
        
        // Yeni seçimi işaretle
        sender.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0.1)
        sender.layer.borderColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0).cgColor
        
        // İçerik stack view'ı bul
        if let contentStack = sender.subviews.first as? UIStackView {
            // Başlık rengini değiştir
            if let titleLabel = contentStack.arrangedSubviews.first as? UILabel {
                titleLabel.textColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
            }
            
            // Açıklama rengini değiştirme - aynı renk kalacak
        }
        
        selectedSkinType = SkinType(rawValue: sender.tag)
        checkContinueButtonState()
    }
    
    private func checkContinueButtonState() {
        if selectedSkinType != nil {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc private func continueButtonTapped() {
        // Seçilen cilt tipini UserDefaults'a kaydet
        if let skinType = selectedSkinType {
            UserDefaults.standard.set(skinType.rawValue, forKey: "userSkinType")
        }
        
        let skinSensitivityVC = SkinSensitivityViewController()
        navigationController?.pushViewController(skinSensitivityVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


