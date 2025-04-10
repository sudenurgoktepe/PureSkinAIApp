import UIKit

class SkinConditionsViewController: UIViewController {
    
    // MARK: - Properties
    private var selectedConditions: Set<SkinCondition> = []
    var isEditingMode: Bool = false
    
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
        imageView.image = UIImage(named: "onboardingimage5")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.7
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cilt Durumlarınız"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Lütfen cildinizde bulunan durumları seçin"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gridStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("İsteğe Bağlı Devam Et", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = .systemGray6
        title = isEditingMode ? "Cilt Durumlarını Düzenle" : "Cilt Durumları"
        setupUI()
        
        if isEditingMode {
            loadExistingData()
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
        contentView.addSubview(gridStackView)
        view.addSubview(continueButton)
        view.addSubview(backButton)
        
        setupConstraints()
        setupGrid()
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
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
            
            gridStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            gridStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            gridStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            gridStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupGrid() {
        // İki satır oluştur
        for row in 0..<2 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 16
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            
            gridStackView.addArrangedSubview(rowStack)
            
            // Her satıra iki buton ekle
            for col in 0..<2 {
                let index = row * 2 + col
                if index < SkinCondition.allCases.count {
                    let condition = SkinCondition.allCases[index]
                    let button = createConditionButton(for: condition)
                    rowStack.addArrangedSubview(button)
                }
            }
        }
    }
    
    private func createConditionButton(for condition: SkinCondition) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(condition.title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        button.tag = condition.rawValue
        
        button.addTarget(self, action: #selector(conditionButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Actions
    @objc private func conditionButtonTapped(_ sender: UIButton) {
        guard let condition = SkinCondition(rawValue: sender.tag) else { return }
        
        if selectedConditions.contains(condition) {
            selectedConditions.remove(condition)
            sender.backgroundColor = .white
            sender.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            selectedConditions.insert(condition)
            sender.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0.2)
            sender.layer.borderColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0).cgColor
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func continueButtonTapped() {
        // Seçilen cilt durumlarını UserDefaults'a kaydet
        let conditionValues = selectedConditions.map { $0.rawValue }
        UserDefaults.standard.set(conditionValues, forKey: "userSkinConditions")
        
        // Bir sonraki sayfaya geç
        let skinAnalysisVC = SkinAnalysisViewController()
        navigationController?.pushViewController(skinAnalysisVC, animated: true)
    }
    
    // MARK: - Helper Methods
    private func loadExistingData() {
        if let savedConditions = UserDefaults.standard.array(forKey: "userSkinConditions") as? [Int] {
            selectedConditions = Set(savedConditions.compactMap { SkinCondition(rawValue: $0) })
            
            // Seçili durumları görsel olarak işaretle
            for rowStack in gridStackView.arrangedSubviews {
                if let rowStack = rowStack as? UIStackView {
                    for button in rowStack.arrangedSubviews {
                        if let button = button as? UIButton,
                           let condition = SkinCondition(rawValue: button.tag),
                           selectedConditions.contains(condition) {
                            button.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0.2)
                            button.layer.borderColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0).cgColor
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Enums
enum SkinCondition: Int, CaseIterable {
    case eczema = 0
    case rosacea = 1
    case psoriasis = 2
    case hives = 3
    
    var title: String {
        switch self {
        case .eczema:
            return "Egzama"
        case .rosacea:
            return "Rozasea"
        case .psoriasis:
            return "Sedef hastalığı"
        case .hives:
            return "Kurdeşen"
        }
    }
} 
