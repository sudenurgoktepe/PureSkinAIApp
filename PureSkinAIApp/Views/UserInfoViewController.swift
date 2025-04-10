import UIKit

class UserInfoViewController: UIViewController {
    
    // MARK: - Properties
    private var selectedGender: Gender?
    private var selectedAgeRange: AgeRange?
    
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
        imageView.image = UIImage(named: "onboardingimage1")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.7 // Solgun görünüm için
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Seni Tanıyalım"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Daha iyi bir deneyim için lütfen cinsiyet ve yaş aralığını seç."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0) // Solgun gri
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cinsiyetiniz"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let ageRangeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Yaş Aralığınız"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageRangeStackView: UIStackView = {
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
        button.alpha = 0.5 // Başlangıçta pasif
        button.isEnabled = false
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
        
        // Scroll view ekleme
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // İçerik elemanlarını ekleme
        contentView.addSubview(headerImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(genderTitleLabel)
        contentView.addSubview(genderStackView)
        contentView.addSubview(ageRangeTitleLabel)
        contentView.addSubview(ageRangeStackView)
        view.addSubview(continueButton)
        
        // Cinsiyet butonlarını oluştur
        setupGenderButtons()
        
        // Yaş aralığı butonlarını oluştur
        setupAgeRangeButtons()
        
        // Constraints
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header image
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            // Gender title
            genderTitleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            genderTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Gender stack view
            genderStackView.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: 20),
            genderStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            genderStackView.heightAnchor.constraint(equalToConstant: 120),
            
            // Age range title
            ageRangeTitleLabel.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 40),
            ageRangeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Age range stack view
            ageRangeStackView.topAnchor.constraint(equalTo: ageRangeTitleLabel.bottomAnchor, constant: 20),
            ageRangeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ageRangeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            ageRangeStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Continue button
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Buton için action
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func setupGenderButtons() {
        let genders: [(title: String, icon: String, gender: Gender)] = [
            ("Kadın", "womengender", .female),
            ("Erkek", "mangender", .male)
        ]
        
        for (title, icon, gender) in genders {
            let button = createGenderButton(title: title, icon: icon, gender: gender)
            genderStackView.addArrangedSubview(button)
        }
    }
    
    private func createGenderButton(title: String, icon: String, gender: Gender) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.tag = gender.rawValue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // İçerik stack view
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 10
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.isUserInteractionEnabled = false // Stack view'ın tıklamaları engellemesini önle
        
        // İkon
        let imageView = UIImageView()
        imageView.image = UIImage(named: icon)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false // Image view'ın tıklamaları engellemesini önle
        
        // Başlık
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.isUserInteractionEnabled = false // Label'ın tıklamaları engellemesini önle
        
        contentStack.addArrangedSubview(imageView)
        contentStack.addArrangedSubview(titleLabel)
        
        button.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            button.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        button.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func setupAgeRangeButtons() {
        let ageRanges: [(title: String, range: AgeRange)] = [
            ("13-17", .range13to17),
            ("18-24", .range18to24),
            ("25-34", .range25to34),
            ("35-44", .range35to44),
            ("45-54", .range45to54),
            ("55+", .range55plus)
        ]
        
        // İki satır için stack view'lar
        let row1Stack = UIStackView()
        row1Stack.axis = .horizontal
        row1Stack.distribution = .fillEqually
        row1Stack.spacing = 15
        row1Stack.translatesAutoresizingMaskIntoConstraints = false
        
        let row2Stack = UIStackView()
        row2Stack.axis = .horizontal
        row2Stack.distribution = .fillEqually
        row2Stack.spacing = 15
        row2Stack.translatesAutoresizingMaskIntoConstraints = false
        
        ageRangeStackView.addArrangedSubview(row1Stack)
        ageRangeStackView.addArrangedSubview(row2Stack)
        
        // İlk 3 butonu ilk satıra ekle
        for i in 0..<3 {
            let button = createAgeRangeButton(title: ageRanges[i].title, range: ageRanges[i].range)
            row1Stack.addArrangedSubview(button)
        }
        
        // Son 3 butonu ikinci satıra ekle
        for i in 3..<6 {
            let button = createAgeRangeButton(title: ageRanges[i].title, range: ageRanges[i].range)
            row2Stack.addArrangedSubview(button)
        }
    }
    
    private func createAgeRangeButton(title: String, range: AgeRange) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.tag = range.rawValue
        
        button.addTarget(self, action: #selector(ageRangeButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    // MARK: - Actions
    @objc private func genderButtonTapped(_ sender: UIButton) {
        // Önceki seçimi temizle
        genderStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton {
                button.backgroundColor = .white
                button.layer.borderColor = UIColor.gray.cgColor
                
                // İçerik stack view'ı bul
                if let contentStack = button.subviews.first as? UIStackView {
                    // Başlık rengini sıfırla
                    if let titleLabel = contentStack.arrangedSubviews.last as? UILabel {
                        titleLabel.textColor = .black
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
            if let titleLabel = contentStack.arrangedSubviews.last as? UILabel {
                titleLabel.textColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
            }
        }
        
        selectedGender = Gender(rawValue: sender.tag)
        checkContinueButtonState()
    }
    
    @objc private func ageRangeButtonTapped(_ sender: UIButton) {
        // Önceki seçimi temizle
        ageRangeStackView.arrangedSubviews.forEach { rowStack in
            if let rowStack = rowStack as? UIStackView {
                rowStack.arrangedSubviews.forEach { view in
                    if let button = view as? UIButton {
                        button.backgroundColor = .white
                        button.setTitleColor(.black, for: .normal)
                        button.layer.borderColor = UIColor.gray.cgColor
                    }
                }
            }
        }
        
        // Yeni seçimi işaretle
        sender.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0.1)
        sender.setTitleColor(UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0), for: .normal)
        sender.layer.borderColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0).cgColor
        
        selectedAgeRange = AgeRange(rawValue: sender.tag)
        checkContinueButtonState()
    }
    
    private func checkContinueButtonState() {
        if selectedGender != nil && selectedAgeRange != nil {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc private func continueButtonTapped() {
        let skinTypeVC = SkinTypeViewController()
        navigationController?.pushViewController(skinTypeVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Enums
enum Gender: Int {
    case female = 0
    case male = 1
}

enum AgeRange: Int {
    case range13to17 = 0
    case range18to24 = 1
    case range25to34 = 2
    case range35to44 = 3
    case range45to54 = 4
    case range55plus = 5
} 