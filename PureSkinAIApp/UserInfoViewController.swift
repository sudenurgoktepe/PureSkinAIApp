import UIKit

class UserInfoViewController: UIViewController {
    
    // MARK: - Properties
    var isEditingMode: Bool = false
    var editingField: EditingField = .age
    
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
        label.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
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
        button.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        if isEditingMode {
            title = editingField == .age ? "Yaş Düzenle" : "Cinsiyet Düzenle"
            loadExistingData()
        } else {
            title = "Seni Tanıyalım"
            navigationController?.setNavigationBarHidden(true, animated: false)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        setupUI()
    }
    
    private func loadExistingData() {
        if let genderRawValue = UserDefaults.standard.object(forKey: "userGender") as? Int {
            selectedGender = Gender(rawValue: genderRawValue)
            updateGenderButtonSelection()
        }
        
        if let ageRangeRawValue = UserDefaults.standard.object(forKey: "userAgeRange") as? Int {
            selectedAgeRange = AgeRange(rawValue: ageRangeRawValue)
            updateAgeRangeButtonSelection()
        }
        
        checkContinueButtonState()
    }
    
    private func updateGenderButtonSelection() {
        guard let selectedGender = selectedGender else { return }
        
        genderStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton, button.tag == selectedGender.rawValue {
                genderButtonTapped(button)
            }
        }
    }
    
    private func updateAgeRangeButtonSelection() {
        guard let selectedAgeRange = selectedAgeRange else { return }
        
        ageRangeStackView.arrangedSubviews.forEach { rowStack in
            if let rowStack = rowStack as? UIStackView {
                rowStack.arrangedSubviews.forEach { view in
                    if let button = view as? UIButton, button.tag == selectedAgeRange.rawValue {
                        ageRangeButtonTapped(button)
                    }
                }
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
        contentView.addSubview(genderTitleLabel)
        contentView.addSubview(genderStackView)
        contentView.addSubview(ageRangeTitleLabel)
        contentView.addSubview(ageRangeStackView)
        view.addSubview(continueButton)
        
        setupGenderButtons()
        setupAgeRangeButtons()
        
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
            headerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            titleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            genderTitleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            genderTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            genderStackView.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: 10),
            genderStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            genderStackView.heightAnchor.constraint(equalToConstant: 120),
            
            ageRangeTitleLabel.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 30),
            ageRangeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ageRangeTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            ageRangeStackView.topAnchor.constraint(equalTo: ageRangeTitleLabel.bottomAnchor, constant: 15),
            ageRangeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ageRangeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            ageRangeStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
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

        genderStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton {
                button.widthAnchor.constraint(equalTo: genderStackView.widthAnchor, multiplier: 0.5, constant: -10).isActive = true
                
            }
        }
    }

    
    private func createGenderButton(title: String, icon: String, gender: Gender) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        button.tag = gender.rawValue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let contentStack = UIStackView()
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 10
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.isUserInteractionEnabled = false
        
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: icon)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.isUserInteractionEnabled = false
        
        contentStack.addArrangedSubview(imageView)
        contentStack.addArrangedSubview(titleLabel)
        
        button.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 15),
            contentStack.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -15),
            
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        button.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
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
        
        for i in 0..<3 {
            let button = createAgeRangeButton(title: ageRanges[i].title, range: ageRanges[i].range)
            row1Stack.addArrangedSubview(button)
        }
        
        for i in 3..<6 {
            let button = createAgeRangeButton(title: ageRanges[i].title, range: ageRanges[i].range)
            row2Stack.addArrangedSubview(button)
        }
        
        if let firstRow = ageRangeStackView.arrangedSubviews.first as? UIStackView,
           let firstButton = firstRow.arrangedSubviews.first {
            firstButton.widthAnchor.constraint(equalTo: firstRow.widthAnchor, multiplier: 1/3, constant: -10).isActive = true
        }
    }
    
    private func createAgeRangeButton(title: String, range: AgeRange) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        button.tag = range.rawValue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(ageRangeButtonTapped(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true // Sabit yükseklik
        
        return button
    }
    
    // MARK: - Actions
    @objc private func genderButtonTapped(_ sender: UIButton) {
    
        genderStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton {
                button.backgroundColor = .white
                button.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
            
                if let contentStack = button.subviews.first as? UIStackView {
                    if let titleLabel = contentStack.arrangedSubviews.last as? UILabel {
                        titleLabel.textColor = .black
                    }
                }
            }
        }
        
        sender.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0.1)
        sender.layer.borderColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0).cgColor
        
        if let contentStack = sender.subviews.first as? UIStackView {
           
            if let titleLabel = contentStack.arrangedSubviews.last as? UILabel {
                titleLabel.textColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
            }
        }
        
        selectedGender = Gender(rawValue: sender.tag)
        checkContinueButtonState()
    }
    
    @objc private func ageRangeButtonTapped(_ sender: UIButton) {
        
        ageRangeStackView.arrangedSubviews.forEach { rowStack in
            if let rowStack = rowStack as? UIStackView {
                rowStack.arrangedSubviews.forEach { view in
                    if let button = view as? UIButton {
                        button.backgroundColor = .white
                        button.setTitleColor(.black, for: .normal)
                        button.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
                    }
                }
            }
        }
        
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
        if let gender = selectedGender, let ageRange = selectedAgeRange {
            UserDefaults.standard.set(gender.rawValue, forKey: "userGender")
            UserDefaults.standard.set(ageRange.rawValue, forKey: "userAgeRange")
        }
        
        let skinTypeVC = SkinTypeViewController()
        navigationController?.pushViewController(skinTypeVC, animated: true)
    }
}
