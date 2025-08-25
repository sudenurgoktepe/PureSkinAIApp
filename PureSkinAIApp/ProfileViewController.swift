import UIKit


class ProfileViewController: UIViewController {
    
    
    func presentBottomSheet(with options: [String], selectedOption: String?, selectionHandler: @escaping (String) -> Void) {
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.options = options
        bottomSheetVC.selectedOption = selectedOption
        bottomSheetVC.onSelect = selectionHandler
        present(bottomSheetVC, animated: false)
    }

    func presentBottomSheetMultiSelect(options: [String], selected: [String], completion: @escaping ([String]) -> Void) {
        let vc = BottomSheetMultiSelectViewController()
        vc.options = options
        vc.selectedOptions = Set(selected)
        vc.onDone = completion
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    private var selectedSkinConditions: Set<SkinCondition> = []
    private var selectedSkinProblems: Set<SkinProblem> = []

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
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "gearshape", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .labelPrimary
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Bölüm 1: Temel Bilgiler
    private let basicInfoCard: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundcolor2
        view.layer.cornerRadius = 17
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let basicInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Temel Bilgiler"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Yaş: "
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Cinsiyet: "
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editAgeButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "pencil.and.scribble", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let editGenderButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "pencil.and.scribble", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Bölüm 2: Cilt Analizi Geçmişi
    private let skinAnalysisCard: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundcolor2
        view.layer.cornerRadius = 17
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let skinAnalysisTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cilt Analizi Geçmişi"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addSelfieButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Selfie Ekle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let selfieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Cildinizin durumunu takip etmek için selfie ekleyin"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Bölüm 3: Cilt Tipi
    private let skinTypeCard: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundcolor2
        view.layer.cornerRadius = 17
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let skinTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cilt Tipi"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skinTypeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Belirtilmemiş"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skinTypeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let editSkinTypeButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "pencil.and.scribble", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Bölüm 4: Cilt Sorunları
    private let skinProblemsCard: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundcolor2
        view.layer.cornerRadius = 17
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let skinProblemsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cilt Sorunları"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skinProblemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let editSkinProblemsButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "pencil.and.scribble", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Bölüm 5: Cilt Hassasiyeti
    private let skinSensitivityCard: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundcolor2
        view.layer.cornerRadius = 17
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let skinSensitivityTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cilt Hassasiyeti"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skinSensitivityValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Belirtilmemiş"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editSkinSensitivityButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "pencil.and.scribble", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Bölüm 6: Cilt Durumları
    private let skinConditionsCard: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundcolor2
        view.layer.cornerRadius = 17
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let skinConditionsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cilt Durumları"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skinConditionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let editSkinConditionsButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "pencil.and.scribble", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserData()
        
        title = "Profil"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
        
        // Navigation bar'ı görünür yap
        navigationController?.setNavigationBarHidden(false, animated: false)
       
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .backgroundcolor
        
        
     
        // Scroll view
        scrollView.backgroundColor = .backgroundcolor
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Temel Bilgiler
        contentView.addSubview(basicInfoCard)
        basicInfoCard.addSubview(basicInfoTitleLabel)
        basicInfoCard.addSubview(ageLabel)
        basicInfoCard.addSubview(genderLabel)
        basicInfoCard.addSubview(editAgeButton)
        basicInfoCard.addSubview(editGenderButton)
        
        // Cilt Analizi Geçmişi
        contentView.addSubview(skinAnalysisCard)
        skinAnalysisCard.addSubview(skinAnalysisTitleLabel)
        skinAnalysisCard.addSubview(addSelfieButton)
        skinAnalysisCard.addSubview(selfieDescriptionLabel)
        
        // Cilt Tipi
        contentView.addSubview(skinTypeCard)
        skinTypeCard.addSubview(skinTypeTitleLabel)
        skinTypeCard.addSubview(skinTypeValueLabel)
        skinTypeCard.addSubview(skinTypeIconImageView)
        skinTypeCard.addSubview(editSkinTypeButton)
        
        // Cilt Sorunları
        contentView.addSubview(skinProblemsCard)
        skinProblemsCard.addSubview(skinProblemsTitleLabel)
        skinProblemsCard.addSubview(skinProblemsStackView)
        skinProblemsCard.addSubview(editSkinProblemsButton)
        
        // Cilt Hassasiyeti
        contentView.addSubview(skinSensitivityCard)
        skinSensitivityCard.addSubview(skinSensitivityTitleLabel)
        skinSensitivityCard.addSubview(skinSensitivityValueLabel)
        skinSensitivityCard.addSubview(editSkinSensitivityButton)
       
        // Cilt Durumlarınız
        contentView.addSubview(skinConditionsCard)
        skinConditionsCard.addSubview(skinConditionsTitleLabel)
        skinConditionsCard.addSubview(skinConditionsStackView)
        skinConditionsCard.addSubview(editSkinConditionsButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Temel Bilgiler
            basicInfoCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            basicInfoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            basicInfoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            basicInfoTitleLabel.topAnchor.constraint(equalTo: basicInfoCard.topAnchor, constant: 20),
            basicInfoTitleLabel.leadingAnchor.constraint(equalTo: basicInfoCard.leadingAnchor, constant: 20),
            
            ageLabel.topAnchor.constraint(equalTo: basicInfoTitleLabel.bottomAnchor, constant: 20),
            ageLabel.leadingAnchor.constraint(equalTo: basicInfoCard.leadingAnchor, constant: 20),
            
            editAgeButton.centerYAnchor.constraint(equalTo: ageLabel.centerYAnchor),
            editAgeButton.trailingAnchor.constraint(equalTo: basicInfoCard.trailingAnchor, constant: -20),
            
            genderLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 20),
            genderLabel.leadingAnchor.constraint(equalTo: basicInfoCard.leadingAnchor, constant: 20),
            genderLabel.bottomAnchor.constraint(equalTo: basicInfoCard.bottomAnchor, constant: -20),
            
            editGenderButton.centerYAnchor.constraint(equalTo: genderLabel.centerYAnchor),
            editGenderButton.trailingAnchor.constraint(equalTo: basicInfoCard.trailingAnchor, constant: -20),
            
            // Cilt Analizi Geçmişi
            skinAnalysisCard.topAnchor.constraint(equalTo: basicInfoCard.bottomAnchor, constant: 20),
            skinAnalysisCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            skinAnalysisCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            skinAnalysisTitleLabel.topAnchor.constraint(equalTo: skinAnalysisCard.topAnchor, constant: 20),
            skinAnalysisTitleLabel.leadingAnchor.constraint(equalTo: skinAnalysisCard.leadingAnchor, constant: 20),
            
            addSelfieButton.topAnchor.constraint(equalTo: skinAnalysisTitleLabel.bottomAnchor, constant: 20),
            addSelfieButton.centerXAnchor.constraint(equalTo: skinAnalysisCard.centerXAnchor),
            addSelfieButton.widthAnchor.constraint(equalToConstant: 200),
            addSelfieButton.heightAnchor.constraint(equalToConstant: 50),
            
            selfieDescriptionLabel.topAnchor.constraint(equalTo: addSelfieButton.bottomAnchor, constant: 10),
            selfieDescriptionLabel.leadingAnchor.constraint(equalTo: skinAnalysisCard.leadingAnchor, constant: 20),
            selfieDescriptionLabel.trailingAnchor.constraint(equalTo: skinAnalysisCard.trailingAnchor, constant: -20),
            selfieDescriptionLabel.bottomAnchor.constraint(equalTo: skinAnalysisCard.bottomAnchor, constant: -20),
            
            // Cilt Tipi
            skinTypeCard.topAnchor.constraint(equalTo: skinAnalysisCard.bottomAnchor, constant: 20),
            skinTypeCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            skinTypeCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            skinTypeTitleLabel.topAnchor.constraint(equalTo: skinTypeCard.topAnchor, constant: 20),
            skinTypeTitleLabel.leadingAnchor.constraint(equalTo: skinTypeCard.leadingAnchor, constant: 20),
            
            skinTypeIconImageView.topAnchor.constraint(equalTo: skinTypeTitleLabel.bottomAnchor, constant: 20),
            skinTypeIconImageView.leadingAnchor.constraint(equalTo: skinTypeCard.leadingAnchor, constant: 20),
            skinTypeIconImageView.bottomAnchor.constraint(equalTo: skinTypeCard.bottomAnchor, constant: -20),
            
            skinTypeValueLabel.centerYAnchor.constraint(equalTo: skinTypeIconImageView.centerYAnchor),
            skinTypeValueLabel.leadingAnchor.constraint(equalTo: skinTypeIconImageView.trailingAnchor, constant: 10),
            
            editSkinTypeButton.centerYAnchor.constraint(equalTo: skinTypeIconImageView.centerYAnchor),
            editSkinTypeButton.trailingAnchor.constraint(equalTo: skinTypeCard.trailingAnchor, constant: -20),
            
            // Cilt Sorunları
            skinProblemsCard.topAnchor.constraint(equalTo: skinTypeCard.bottomAnchor, constant: 20),
            skinProblemsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            skinProblemsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            skinProblemsTitleLabel.topAnchor.constraint(equalTo: skinProblemsCard.topAnchor, constant: 20),
            skinProblemsTitleLabel.leadingAnchor.constraint(equalTo: skinProblemsCard.leadingAnchor, constant: 20),
            
            skinProblemsStackView.topAnchor.constraint(equalTo: skinProblemsTitleLabel.bottomAnchor, constant: 20),
            skinProblemsStackView.leadingAnchor.constraint(equalTo: skinProblemsCard.leadingAnchor, constant: 20),
            skinProblemsStackView.trailingAnchor.constraint(equalTo: skinProblemsCard.trailingAnchor, constant: -20),
            skinProblemsStackView.bottomAnchor.constraint(equalTo: skinProblemsCard.bottomAnchor, constant: -20),
            
            editSkinProblemsButton.topAnchor.constraint(equalTo: skinProblemsTitleLabel.topAnchor),
            editSkinProblemsButton.trailingAnchor.constraint(equalTo: skinProblemsCard.trailingAnchor, constant: -20),
            
            // Cilt Hassasiyeti
            skinSensitivityCard.topAnchor.constraint(equalTo: skinProblemsCard.bottomAnchor, constant: 20),
            skinSensitivityCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            skinSensitivityCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            skinSensitivityTitleLabel.topAnchor.constraint(equalTo: skinSensitivityCard.topAnchor, constant: 20),
            skinSensitivityTitleLabel.leadingAnchor.constraint(equalTo: skinSensitivityCard.leadingAnchor, constant: 20),
            
            skinSensitivityValueLabel.topAnchor.constraint(equalTo: skinSensitivityTitleLabel.bottomAnchor, constant: 20),
            skinSensitivityValueLabel.leadingAnchor.constraint(equalTo: skinSensitivityCard.leadingAnchor, constant: 20),
            skinSensitivityValueLabel.bottomAnchor.constraint(equalTo: skinSensitivityCard.bottomAnchor, constant: -20),
            
            editSkinSensitivityButton.centerYAnchor.constraint(equalTo: skinSensitivityValueLabel.centerYAnchor),
            editSkinSensitivityButton.trailingAnchor.constraint(equalTo: skinSensitivityCard.trailingAnchor, constant: -20),
            
            // Cilt Durumlarınız
            skinConditionsCard.topAnchor.constraint(equalTo: skinSensitivityCard.bottomAnchor, constant: 20),
            skinConditionsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            skinConditionsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            skinConditionsCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Başlık Label
            skinConditionsTitleLabel.topAnchor.constraint(equalTo: skinConditionsCard.topAnchor, constant: 20),
            skinConditionsTitleLabel.leadingAnchor.constraint(equalTo: skinConditionsCard.leadingAnchor, constant: 20),
            
            skinConditionsStackView.topAnchor.constraint(equalTo: skinConditionsTitleLabel.bottomAnchor, constant: 20),
            skinConditionsStackView.leadingAnchor.constraint(equalTo: skinConditionsCard.leadingAnchor, constant: 20),
            skinConditionsStackView.trailingAnchor.constraint(equalTo: skinConditionsCard.trailingAnchor, constant: -20),
            skinConditionsStackView.bottomAnchor.constraint(equalTo: skinConditionsCard.bottomAnchor, constant: -20),
            
            // Düzenle Butonu
            editSkinConditionsButton.centerYAnchor.constraint(equalTo: skinConditionsTitleLabel.centerYAnchor),
            editSkinConditionsButton.trailingAnchor.constraint(equalTo: skinConditionsCard.trailingAnchor, constant: -20),
            editSkinConditionsButton.widthAnchor.constraint(equalToConstant: 30),
            editSkinConditionsButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        // Butonlar için action
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        addSelfieButton.addTarget(self, action: #selector(addSelfieButtonTapped), for: .touchUpInside)
        editAgeButton.addTarget(self, action: #selector(editAgeButtonTapped), for: .touchUpInside)
        editGenderButton.addTarget(self, action: #selector(editGenderButtonTapped), for: .touchUpInside)
        editSkinTypeButton.addTarget(self, action: #selector(editSkinTypeButtonTapped), for: .touchUpInside)

        editSkinProblemsButton.addTarget(self, action: #selector(editSkinProblemsButtonTapped), for: .touchUpInside)
        editSkinSensitivityButton.addTarget(self, action: #selector(editSkinSensitivityButtonTapped), for: .touchUpInside)
        editSkinConditionsButton.addTarget(self, action: #selector(editSkinConditionsButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - User Data
    private func loadUserData() {
        selectedSkinConditions = []
        
        
        // Temel Bilgiler
        if let genderRawValue = UserDefaults.standard.object(forKey: "userGender") as? Int,
           let ageRangeRawValue = UserDefaults.standard.object(forKey: "userAgeRange") as? Int {
            
            let gender = Gender(rawValue: genderRawValue)
            let ageRange = AgeRange(rawValue: ageRangeRawValue)
            
            genderLabel.text = "Cinsiyet: \(gender == .female ? "Kadın" : "Erkek")"
            
            if let ageRange = ageRange {
                switch ageRange {
                case .range13to17:
                    ageLabel.text = "Yaş: 13-17"
                case .range18to24:
                    ageLabel.text = "Yaş: 18-24"
                case .range25to34:
                    ageLabel.text = "Yaş: 25-34"
                case .range35to44:
                    ageLabel.text = "Yaş: 35-44"
                case .range45to54:
                    ageLabel.text = "Yaş: 45-54"
                case .range55plus:
                    ageLabel.text = "Yaş: 55+"
                case .none:
                    ageLabel.text = "Yaş: Belirtilmemiş"
                }
            } else {
                ageLabel.text = "Yaş: Belirtilmemiş"
            }
        }
        
        // Cilt Tipi
        if let skinTypeRawValue = UserDefaults.standard.object(forKey: "userSkinType") as? Int,
           let skinType = SkinType(rawValue: skinTypeRawValue) {
            
            switch skinType {
            case .normal:
                skinTypeValueLabel.text = "Normal"
                skinTypeIconImageView.image = UIImage(systemName: "sun.max.fill")
            case .dry:
                skinTypeValueLabel.text = "Kuru"
                skinTypeIconImageView.image = UIImage(systemName: "wind")
            case .oily:
                skinTypeValueLabel.text = "Yağlı"
                skinTypeIconImageView.image = UIImage(systemName: "drop.triangle")
            case .combination:
                skinTypeValueLabel.text = "Karma"
                skinTypeIconImageView.image = UIImage(systemName: "circle.lefthalf.filled")
            case .sensitive:
                skinTypeValueLabel.text = "Hassas"
                skinTypeIconImageView.image = UIImage(systemName: "exclamationmark.triangle")
            }
            
        }
        
        // Cilt Hassasiyeti
        
        if let sensitivityRawValue = UserDefaults.standard.object(forKey: "userSkinSensitivity") as? Int,
           let sensitivity = SkinSensitivity(rawValue: sensitivityRawValue) {
            
            switch sensitivity {
            case .notSensitive:
                skinSensitivityValueLabel.text = "Hassas Değil"
            case .slightlySensitive:
                skinSensitivityValueLabel.text = "Biraz Hassas"
            case .moderatelySensitive:
                skinSensitivityValueLabel.text = "Orta Hassas"
            case .verySensitive:
                skinSensitivityValueLabel.text = "Çok Hassas"
            }
        }
        
        // Cilt Sorunları
        if let problemsArray = UserDefaults.standard.array(forKey: "userSkinProblems") as? [Int] {
            let problems = problemsArray.compactMap { SkinProblem(rawValue: $0) }
            self.selectedSkinProblems = Set(problems) 
            
            skinProblemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for problem in problems {
                let view = createProblemView(problem: problem)
                skinProblemsStackView.addArrangedSubview(view)
            }
        }
        
        // Cilt Durumları
        if let rawValues = UserDefaults.standard.array(forKey: "userSkinConditions") as? [Int] {
            let conditions = rawValues.compactMap { SkinCondition(rawValue: $0) }
            self.selectedSkinConditions = Set(conditions)
            
            skinConditionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for condition in conditions {
                let view = createConditionView(condition: condition.title)
                skinConditionsStackView.addArrangedSubview(view)
            }
        }
    }
    
    private func createProblemView(problem: SkinProblem) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let checkmarkImageView = UIImageView()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "exclamationmark.circle.fill", withConfiguration: imageConfig)
        checkmarkImageView.image = image
        checkmarkImageView.tintColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = problem.title
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(checkmarkImageView)
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 30),
            
            checkmarkImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
            
            label.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        return containerView
    }
    
    private func createConditionView(condition: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        
        // Duruma göre ikon belirle (isteğe bağlı)
        var image: UIImage?
        switch condition {
        case "Egzama":
            image = UIImage(systemName: "allergens", withConfiguration: imageConfig)
        case "Rozasea":
            image = UIImage(systemName: "flame", withConfiguration: imageConfig)
        case "Sedef hastalığı":
            image = UIImage(systemName: "circle.dotted", withConfiguration: imageConfig)
        case "Kurdeşen":
            image = UIImage(systemName: "circle.grid.hex", withConfiguration: imageConfig)
        default:
            image = UIImage(systemName: "circle", withConfiguration: imageConfig)
        }
        
        iconImageView.image = image
        iconImageView.tintColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = condition
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 30),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        return containerView
    }
    
    // MARK: - Actions
    @objc private func settingsButtonTapped() {
        // Ayarlar sayfasına yönlendirme
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func addSelfieButtonTapped() {
        // Kamera açma işlemi
        print("Selfie ekle butonuna tıklandı")
    }
    
    @objc private func editAgeButtonTapped() {
        let currentAgeRaw = UserDefaults.standard.integer(forKey: "userAgeRange")
        let currentAge = AgeRange(rawValue: currentAgeRaw)
        let currentAgeTitle = currentAge?.displayName

        presentBottomSheet(with: AgeRange.allTitles, selectedOption: currentAgeTitle) { selected in
            if let selectedAge = AgeRange.allCases.first(where: { $0.displayName == selected }) {
                UserDefaults.standard.set(selectedAge.rawValue, forKey: "userAgeRange")
                self.ageLabel.text = "Yaş: \(selected)"
            }
        }
    }

    @objc private func editGenderButtonTapped() {
        let currentGenderRaw = UserDefaults.standard.integer(forKey: "userGender")
        let currentGender = Gender(rawValue: currentGenderRaw)
        let currentGenderTitle = currentGender?.displayName

        presentBottomSheet(with: Gender.allTitles, selectedOption: currentGenderTitle) { selected in
            if let selectedGender = Gender.allCases.first(where: { $0.displayName == selected }) {
                UserDefaults.standard.set(selectedGender.rawValue, forKey: "userGender")
                self.genderLabel.text = "Cinsiyet: \(selectedGender.displayName)"
            }
        }
    }

    
    @objc private func editSkinTypeButtonTapped() {
        let currentSkinTypeRaw = UserDefaults.standard.integer(forKey: "userSkinType")
        let currentSkinType = SkinType(rawValue: currentSkinTypeRaw)
        let currentSkinTypeTitle = currentSkinType?.displayName

        presentBottomSheet(with: SkinType.allTitles, selectedOption: currentSkinTypeTitle) { selected in
            guard let selectedSkinType = SkinType.allCases.first(where: { $0.displayName == selected }) else {
                return
            }

            UserDefaults.standard.set(selectedSkinType.rawValue, forKey: "userSkinType")
            self.skinTypeValueLabel.text = selected

            switch selectedSkinType {
            case .normal:
                self.skinTypeIconImageView.image = UIImage(systemName: "sun.max.fill")
            case .dry:
                self.skinTypeIconImageView.image = UIImage(systemName: "wind")
            case .oily:
                self.skinTypeIconImageView.image = UIImage(systemName: "drop.triangle")
            case .combination:
                self.skinTypeIconImageView.image = UIImage(systemName: "circle.lefthalf.filled")
            case .sensitive:
                self.skinTypeIconImageView.image = UIImage(systemName: "exclamationmark.triangle")
            }
        }
    }

    @objc private func editSkinProblemsButtonTapped() {
        let titles = SkinProblem.allTitles
        let currentSelections = selectedSkinProblems.map { $0.title }

        presentBottomSheetMultiSelect(
            options: titles,
            selected: currentSelections
        ) { selectedOptions in
            let selected = SkinProblem.allCases.filter { selectedOptions.contains($0.title) }
            self.selectedSkinProblems = Set(selected)

            let rawValues = selected.map { $0.rawValue }
            UserDefaults.standard.set(rawValues, forKey: "userSkinProblems")

            self.skinProblemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for problem in selected {
                let view = self.createProblemView(problem: problem)
                self.skinProblemsStackView.addArrangedSubview(view)
            }
        }
    }


    @objc private func editSkinSensitivityButtonTapped() {
        let currentSensitivityRaw = UserDefaults.standard.integer(forKey: "userSkinSensitivity")
        let currentSensitivity = SkinSensitivity(rawValue: currentSensitivityRaw)
        let currentSensitivityTitle = currentSensitivity?.displayName

        presentBottomSheet(with: SkinSensitivity.allTitles, selectedOption: currentSensitivityTitle) { selected in
            guard let selectedSensitivity = SkinSensitivity.allCases.first(where: { $0.displayName == selected }) else {
                return
            }

            UserDefaults.standard.set(selectedSensitivity.rawValue, forKey: "userSkinSensitivity")
            self.skinSensitivityValueLabel.text = selected
        }
    }
    
    @objc private func editSkinConditionsButtonTapped() {
        let conditionTitles = SkinCondition.allTitles
        let currentSelections = selectedSkinConditions.map { $0.title }

        presentBottomSheetMultiSelect(
            options: conditionTitles,
            selected: currentSelections
        ) { selectedOptions in
            let selected = SkinCondition.allCases.filter { selectedOptions.contains($0.title) }
            self.selectedSkinConditions = Set(selected)

            let rawValues = selected.map { $0.rawValue }
            UserDefaults.standard.set(rawValues, forKey: "userSkinConditions")

            self.skinConditionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for condition in selected {
                let view = self.createConditionView(condition: condition.title)
                self.skinConditionsStackView.addArrangedSubview(view)
            }
        }
    }
}

