import UIKit

class SkinConditionsViewController: UIViewController {
    
    // MARK: - Properties
    private var selectedConditions: Set<SkinCondition> = []
    
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
        label.text = "Cilt Durumlarınız"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Aşağıdaki durumlardan herhangi birine sahipseniz, lütfen seçin. Bu bilgi, size kişiye özel öneriler sunmamıza yardımcı olacak."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let conditionsStackView: UIStackView = {
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
        button.setTitle("İsteğe Bağlı Devam Et", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
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
        contentView.addSubview(conditionsStackView)
        view.addSubview(continueButton)
        view.addSubview(backButton)
        
        setupConditionsGrid()
        
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
            
            conditionsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            conditionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            conditionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            conditionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func setupConditionsGrid() {
        let conditions: [(title: String, condition: SkinCondition)] = [
            ("Egzama", .eczema),
            ("Rozasea", .rosacea),
            ("Sedef hastalığı", .psoriasis),
            ("Kurdeşen", .hives)
        ]
        
        // İki satır oluştur
        for rowIndex in 0..<2 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 15
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            
            conditionsStackView.addArrangedSubview(rowStack)
            
            // Her satıra 2 buton ekle
            for colIndex in 0..<2 {
                let index = rowIndex * 2 + colIndex
                if index < conditions.count {
                    let button = createConditionButton(title: conditions[index].title, condition: conditions[index].condition)
                    rowStack.addArrangedSubview(button)
                }
            }
        }
    }
    
    private func createConditionButton(title: String, condition: SkinCondition) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.tag = condition.rawValue
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: button.topAnchor, constant: 15),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -15)
        ])
        
        button.addTarget(self, action: #selector(conditionButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    // MARK: - Actions
    @objc private func conditionButtonTapped(_ sender: UIButton) {
        let condition = SkinCondition(rawValue: sender.tag)!
        
        if selectedConditions.contains(condition) {
            // Seçimi kaldır
            selectedConditions.remove(condition)
            sender.backgroundColor = .white
            sender.layer.borderColor = UIColor.gray.cgColor
            if let label = sender.subviews.first as? UILabel {
                label.textColor = .gray
            }
        } else {
            // Seçimi ekle
            selectedConditions.insert(condition)
            sender.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0.1)
            sender.layer.borderColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0).cgColor
            if let label = sender.subviews.first as? UILabel {
                label.textColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
            }
        }
        
        checkContinueButtonState()
    }
    
    private func checkContinueButtonState() {
        continueButton.alpha = 1.0
        continueButton.isEnabled = true
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func continueButtonTapped() {
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
}

// MARK: - Enums
enum SkinCondition: Int {
    case eczema = 0
    case rosacea = 1
    case psoriasis = 2
    case hives = 3
} 