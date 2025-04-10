import UIKit

// AgeRange enum'ını kaldırıyorum çünkü UserInfoViewController.swift dosyasında zaten tanımlanmış

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profil"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "gearshape.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Bölüm 1: Temel Bilgiler
    private let basicInfoCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
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
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Yaş: 55+"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Cinsiyet: Erkek"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editAgeButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "pencil", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let editGenderButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "pencil", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Bölüm 2: Cilt Analizi Geçmişi
    private let skinAnalysisCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
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
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addSelfieButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Selfie Ekle", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let selfieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Cilt ilerlemenizi takip etmek için selfie ekleyin"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Bölüm 3: Cilt Tipi
    private let skinTypeCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
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
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skinTypeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Yağlı"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skinTypeIconImageView: UIImageView = {
        let imageView = UIImageView()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "drop.fill", withConfiguration: imageConfig)
        imageView.image = image
        imageView.tintColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let editSkinTypeButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "pencil", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Bölüm 4: Cilt Sorunları
    private let skinProblemsCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
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
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skinProblemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let editSkinProblemsButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "pencil", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Bölüm 5: Cilt Hassasiyeti
    private let skinSensitivityCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
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
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skinSensitivityValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Çok Hassas"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editSkinSensitivityButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "pencil", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Yaş seçim arayüzü için yeni özellikler
    private var ageSelectionView: UIView?
    private var ageSelectionPanGesture: UIPanGestureRecognizer?
    private var ageSelectionInitialY: CGFloat = 0
    private var ageSelectionCurrentY: CGFloat = 0
    private var ageSelectionHeight: CGFloat = 0
    private var ageSelectionViewHeight: CGFloat = 0
    private var ageOptions: [AgeRange] = [.range13to17, .range18to24, .range25to34, .range35to44, .range45to54, .range55plus, .none]
    private var selectedAgeOption: AgeRange?
    private var ageSelectionTableView: UITableView?
    private var ageSelectionTitleLabel: UILabel?
    private var ageSelectionDoneButton: UIButton?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Header view
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(settingsButton)
        
        // Scroll view
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
        
        // Constraints
        NSLayoutConstraint.activate([
            // Header view
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            
            settingsButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10), // Tab bar için boşluğu azalttım
            
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
            skinSensitivityCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            skinSensitivityTitleLabel.topAnchor.constraint(equalTo: skinSensitivityCard.topAnchor, constant: 20),
            skinSensitivityTitleLabel.leadingAnchor.constraint(equalTo: skinSensitivityCard.leadingAnchor, constant: 20),
            
            skinSensitivityValueLabel.topAnchor.constraint(equalTo: skinSensitivityTitleLabel.bottomAnchor, constant: 20),
            skinSensitivityValueLabel.leadingAnchor.constraint(equalTo: skinSensitivityCard.leadingAnchor, constant: 20),
            skinSensitivityValueLabel.bottomAnchor.constraint(equalTo: skinSensitivityCard.bottomAnchor, constant: -20),
            
            editSkinSensitivityButton.centerYAnchor.constraint(equalTo: skinSensitivityValueLabel.centerYAnchor),
            editSkinSensitivityButton.trailingAnchor.constraint(equalTo: skinSensitivityCard.trailingAnchor, constant: -20)
        ])
        
        // Butonlar için action
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        addSelfieButton.addTarget(self, action: #selector(addSelfieButtonTapped), for: .touchUpInside)
        editAgeButton.addTarget(self, action: #selector(editAgeButtonTapped), for: .touchUpInside)
        editGenderButton.addTarget(self, action: #selector(editGenderButtonTapped), for: .touchUpInside)
        editSkinTypeButton.addTarget(self, action: #selector(editSkinTypeButtonTapped), for: .touchUpInside)
        editSkinProblemsButton.addTarget(self, action: #selector(editSkinProblemsButtonTapped), for: .touchUpInside)
        editSkinSensitivityButton.addTarget(self, action: #selector(editSkinSensitivityButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - User Data
    private func loadUserData() {
        // Temel Bilgiler
        if let genderRawValue = UserDefaults.standard.object(forKey: "userGender") as? Int,
           let ageRangeRawValue = UserDefaults.standard.object(forKey: "userAgeRange") as? Int {
            
            let gender = Gender(rawValue: genderRawValue)
            let ageRange = AgeRange(rawValue: ageRangeRawValue)
            
            genderLabel.text = "Cinsiyet: \(gender == .female ? "Kadın" : "Erkek")"
            
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
            case nil:
                ageLabel.text = "Yaş: Belirtilmemiş"
            case .some(.none):
                ageLabel.text = "Yaş: Belirtilmemiş"
            }
        }
        
        // Cilt Tipi
        if let skinTypeRawValue = UserDefaults.standard.object(forKey: "userSkinType") as? Int,
           let skinType = SkinType(rawValue: skinTypeRawValue) {
            
            switch skinType {
            case .normal:
                skinTypeValueLabel.text = "Normal"
            case .dry:
                skinTypeValueLabel.text = "Kuru"
            case .oily:
                skinTypeValueLabel.text = "Yağlı"
            case .combination:
                skinTypeValueLabel.text = "Karma"
            case .sensitive:
                skinTypeValueLabel.text = "Hassas"
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
            // Önce mevcut sorunları temizle
            skinProblemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            // Yeni sorunları ekle
            for problemRawValue in problemsArray {
                if let problem = SkinProblem(rawValue: problemRawValue) {
                    let problemView = createProblemView(problem: problem)
                    skinProblemsStackView.addArrangedSubview(problemView)
                }
            }
        }
    }
    
    private func createProblemView(problem: SkinProblem) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let checkmarkImageView = UIImageView()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)
        checkmarkImageView.image = image
        checkmarkImageView.tintColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = problem.title
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
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
    
    // MARK: - Actions
    @objc private func settingsButtonTapped() {
        // Ayarlar sayfasına yönlendirme
        print("Ayarlar butonuna tıklandı")
    }
    
    @objc private func addSelfieButtonTapped() {
        // Kamera açma işlemi
        print("Selfie ekle butonuna tıklandı")
    }
    
    @objc private func editAgeButtonTapped() {
        // Yaş seçim arayüzünü göster
        showAgeSelectionView()
    }
    
    @objc private func editGenderButtonTapped() {
        // Cinsiyet düzenleme sayfasına yönlendirme
        let userInfoVC = UserInfoViewController()
        userInfoVC.isEditingMode = true
        userInfoVC.editingField = .gender
        navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    @objc private func editSkinTypeButtonTapped() {
        // Cilt tipi düzenleme sayfasına yönlendirme
        let skinTypeVC = SkinTypeViewController()
        skinTypeVC.isEditingMode = true
        navigationController?.pushViewController(skinTypeVC, animated: true)
    }
    
    @objc private func editSkinProblemsButtonTapped() {
        // Cilt sorunları düzenleme sayfasına yönlendirme
        let skinProblemsVC = SkinProblemsViewController()
        skinProblemsVC.isEditingMode = true
        navigationController?.pushViewController(skinProblemsVC, animated: true)
    }
    
    @objc private func editSkinSensitivityButtonTapped() {
        // Cilt hassasiyeti düzenleme sayfasına yönlendirme
        let skinSensitivityVC = SkinSensitivityViewController()
        skinSensitivityVC.isEditingMode = true
        navigationController?.pushViewController(skinSensitivityVC, animated: true)
    }
    
    // MARK: - Yaş Seçim Arayüzü
    private func showAgeSelectionView() {
        // Eğer zaten gösteriliyorsa, tekrar gösterme
        if ageSelectionView != nil {
            return
        }
        
        // Tab bar'ı gizle
        tabBarController?.tabBar.isHidden = true
        
        // Ekran yüksekliğinin %40'ı kadar bir yükseklik belirle
        ageSelectionViewHeight = view.frame.height * 0.4
        
        // Ana görünümü oluştur
        let selectionView = UIView()
        selectionView.backgroundColor = .white
        selectionView.layer.cornerRadius = 20
        selectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        selectionView.layer.shadowColor = UIColor.black.cgColor
        selectionView.layer.shadowOpacity = 0.2
        selectionView.layer.shadowOffset = CGSize(width: 0, height: -2)
        selectionView.layer.shadowRadius = 5
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Başlık etiketi
        let titleLabel = UILabel()
        titleLabel.text = "Yaş"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Yaş seçenekleri için collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        // Her satırda 2 öğe olacak şekilde ayarla
        let itemWidth = (UIScreen.main.bounds.width - 55) / 2 // 55 = sol padding (20) + sağ padding (20) + aralarındaki boşluk (15)
        layout.itemSize = CGSize(width: itemWidth, height: 50)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "AgeCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Kaydırma çizgisi
        let dragIndicator = UIView()
        dragIndicator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        dragIndicator.layer.cornerRadius = 2.5
        dragIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Görünümleri ekle
        selectionView.addSubview(dragIndicator)
        selectionView.addSubview(titleLabel)
        selectionView.addSubview(collectionView)
        
        // Ana görünüme ekle
        view.addSubview(selectionView)
        
        // Constraint'leri ayarla
        NSLayoutConstraint.activate([
            selectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectionView.heightAnchor.constraint(equalToConstant: ageSelectionViewHeight),
            selectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: ageSelectionViewHeight), // Tab bar'ın üstünde olması için safeAreaLayoutGuide kullanıyoruz
            
            dragIndicator.topAnchor.constraint(equalTo: selectionView.topAnchor, constant: 10),
            dragIndicator.centerXAnchor.constraint(equalTo: selectionView.centerXAnchor),
            dragIndicator.widthAnchor.constraint(equalToConstant: 40),
            dragIndicator.heightAnchor.constraint(equalToConstant: 5),
            
            titleLabel.topAnchor.constraint(equalTo: dragIndicator.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: selectionView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: selectionView.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: selectionView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: selectionView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: selectionView.bottomAnchor)
        ])
        
        // Pan gesture recognizer ekle
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleAgeSelectionPanGesture(_:)))
        selectionView.addGestureRecognizer(panGesture)
        
        // Referansları sakla
        ageSelectionView = selectionView
        ageSelectionPanGesture = panGesture
        ageSelectionTableView = nil // Artık tableView kullanmıyoruz
        ageSelectionTitleLabel = titleLabel
        
        // Animasyonla göster
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            selectionView.transform = CGAffineTransform(translationX: 0, y: -self.ageSelectionViewHeight)
        }, completion: nil)
    }
    
    @objc private func handleAgeSelectionPanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let selectionView = ageSelectionView else { return }
        
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            ageSelectionInitialY = selectionView.frame.origin.y
            ageSelectionCurrentY = ageSelectionInitialY
            ageSelectionHeight = selectionView.frame.height
        case .changed:
            ageSelectionCurrentY = ageSelectionInitialY + translation.y
            
            // Sadece yukarı kaydırmaya izin ver
            if ageSelectionCurrentY > ageSelectionInitialY {
                selectionView.frame.origin.y = ageSelectionCurrentY
            }
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: view)
            
            // Eğer kullanıcı hızlı bir şekilde aşağı kaydırırsa veya yarıdan fazla aşağı kaydırırsa, görünümü kapat
            if velocity.y > 500 || (ageSelectionCurrentY - ageSelectionInitialY) > (ageSelectionHeight / 2) {
                hideAgeSelectionView()
            } else {
                // Aksi takdirde, görünümü tekrar göster
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    selectionView.frame.origin.y = self.ageSelectionInitialY
                }, completion: nil)
            }
        default:
            break
        }
    }
    
    private func hideAgeSelectionView() {
        guard let selectionView = ageSelectionView else { return }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            selectionView.transform = CGAffineTransform(translationX: 0, y: self.ageSelectionViewHeight)
        }, completion: { _ in
            selectionView.removeFromSuperview()
            self.ageSelectionView = nil
            self.ageSelectionTableView = nil
            self.ageSelectionTitleLabel = nil
            
            // Tab bar'ı tekrar göster
            self.tabBarController?.tabBar.isHidden = false
        })
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ageOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AgeCell", for: indexPath)
        
        // Hücre içeriğini temizle
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Yaş seçeneğini al
        let ageOption = ageOptions[indexPath.row]
        
        // Yaş aralığını metin olarak belirle
        var ageText = ""
        switch ageOption {
        case .range13to17:
            ageText = "13-17"
        case .range18to24:
            ageText = "18-24"
        case .range25to34:
            ageText = "25-34"
        case .range35to44:
            ageText = "35-44"
        case .range45to54:
            ageText = "45-54"
        case .range55plus:
            ageText = "55+"
        case .none:
            ageText = "Belirtilmemiş"
        }
        
        // Hücre arka planını ayarla
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 8
        
        // Eğer bu seçenek zaten seçiliyse, yeşil kenarlık ve onay işareti ekle
        if ageOption == selectedAgeOption {
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0).cgColor
        } else {
            cell.layer.borderWidth = 0
        }
        
        // Yaş etiketi
        let label = UILabel()
        label.text = ageText
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)
        
        // Onay işareti (eğer seçiliyse)
        if ageOption == selectedAgeOption {
            let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
            checkmarkImageView.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
            checkmarkImageView.contentMode = .scaleAspectFit
            checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(checkmarkImageView)
            
            NSLayoutConstraint.activate([
                checkmarkImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                checkmarkImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
                checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
        
        // Etiket constraint'leri
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10)
        ])
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Seçilen yaş seçeneğini güncelle
        selectedAgeOption = ageOptions[indexPath.row]
        
        // Seçilen yaşı UserDefaults'a kaydet
        if let selectedAge = selectedAgeOption {
            UserDefaults.standard.set(selectedAge.rawValue, forKey: "userAgeRange")
            
            // Yaş etiketini güncelle
            switch selectedAge {
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
        }
        
        // Seçim arayüzünü kapat
        hideAgeSelectionView()
    }
} 
