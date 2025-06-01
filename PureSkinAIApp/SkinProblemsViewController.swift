import UIKit

class SkinProblemsViewController: UIViewController {
    
    // MARK: - Properties
    var isEditingMode: Bool = false
    private var selectedProblems: Set<SkinProblem> = []
    
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
        imageView.image = UIImage(named: "onboardingimage4")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.7
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cilt Sorunlarınız"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Aşağıdaki sorunlardan hangilerine sahipsiniz?"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let problemsGridView: UIStackView = {
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
        view.backgroundColor = .systemGray6
        title = isEditingMode ? "Cilt Sorunlarını Düzenle" : "Cilt Sorunları"
        
        if isEditingMode {
            loadExistingData()
        }
        
        setupUI()
    }
    
    private func loadExistingData() {
        if let problemsArray = UserDefaults.standard.array(forKey: "userSkinProblems") as? [Int] {
            selectedProblems = Set(problemsArray.compactMap { SkinProblem(rawValue: $0) })
            updateProblemsButtonSelection()
        }
        
        checkContinueButtonState()
    }
    
    private func updateProblemsButtonSelection() {
        problemsGridView.arrangedSubviews.forEach { rowStack in
            if let rowStack = rowStack as? UIStackView {
                rowStack.arrangedSubviews.forEach { view in
                    if let button = view as? UIButton,
                       let problem = SkinProblem(rawValue: button.tag),
                       selectedProblems.contains(problem) {
                        problemButtonTapped(button)
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
        contentView.addSubview(problemsGridView)
        view.addSubview(continueButton)
        view.addSubview(backButton)
        
        setupProblemsGrid()
        
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
            
            problemsGridView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            problemsGridView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            problemsGridView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            problemsGridView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func setupProblemsGrid() {
        let problems: [(title: String, problem: SkinProblem)] = [
            ("Donuk cilt", .dullSkin),
            ("Hassas cilt", .sensitiveSkin),
            ("Çok kuru cilt", .veryDrySkin),
            ("Akne izleri", .acneScars),
            ("Kızarıklık", .redness),
            ("Gözenekler", .pores),
            ("Düzensiz doku", .unevenTexture),
            ("İnce çizgiler", .fineLines),
            ("Kırışıklıklar", .wrinkles),
            ("Esneklik kaybı", .lossOfElasticity),
            ("Şişkinlik", .swelling),
            ("Göz altı morlukları", .darkCircles)
        ]
        
        // 4 satır oluştur
        for rowIndex in 0..<4 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 15
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            
            problemsGridView.addArrangedSubview(rowStack)
            
            // Her satıra 3 buton ekle
            for colIndex in 0..<3 {
                let index = rowIndex * 3 + colIndex
                if index < problems.count {
                    let button = createProblemButton(title: problems[index].title, problem: problems[index].problem)
                    rowStack.addArrangedSubview(button)
                }
            }
        }
    }
    
    private func createProblemButton(title: String, problem: SkinProblem) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        button.tag = problem.rawValue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(problemButtonTapped(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }
    
    // MARK: - Actions
    @objc private func problemButtonTapped(_ sender: UIButton) {
        let problem = SkinProblem(rawValue: sender.tag)!
        
        if selectedProblems.contains(problem) {
            // Seçimi kaldır
            selectedProblems.remove(problem)
            sender.backgroundColor = .white
            sender.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        } else {
            // Seçimi ekle
            selectedProblems.insert(problem)
            sender.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0.1)
            sender.layer.borderColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0).cgColor
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
        // Seçilen cilt sorunlarını UserDefaults'a kaydet
        let selectedProblemsArray = Array(selectedProblems).map { $0.rawValue }
        UserDefaults.standard.set(selectedProblemsArray, forKey: "userSkinProblems")
        
        let skinConditionsVC = SkinConditionsViewController()
        navigationController?.pushViewController(skinConditionsVC, animated: true)
    }
}


