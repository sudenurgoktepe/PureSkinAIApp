import UIKit

class SkinConditionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var isEditingMode: Bool = false
    
    private let conditions: [String] = [
        "Akne",
        "Rozasea",
        "Egzama",
        "Sedef",
        "Vitiligo",
        "Diğer"
    ]
    
    private var selectedConditions: Set<String> = []
    private var customCondition: String = ""
    
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
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let customConditionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Cilt durumunuzu yazın"
        textField.borderStyle = .roundedRect
        textField.isHidden = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        view.backgroundColor = .systemBackground
        title = "Cilt Durumları"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(gridStackView)
        view.addSubview(continueButton)
        view.addSubview(backButton)
        view.addSubview(tableView)
        view.addSubview(customConditionTextField)
        
        setupConstraints()
        setupGrid()
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
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
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: customConditionTextField.topAnchor, constant: -20),
            
            customConditionTextField.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            customConditionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customConditionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customConditionTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupGrid() {
        for row in 0..<2 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 16
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            
            gridStackView.addArrangedSubview(rowStack)
            
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
        
        if selectedConditions.contains(condition.title) {
            selectedConditions.remove(condition.title)
            sender.backgroundColor = .white
            sender.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            selectedConditions.insert(condition.title)
            sender.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0.2)
            sender.layer.borderColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0).cgColor
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func continueButtonTapped() {
       
        let conditionValues = Array(selectedConditions)
        UserDefaults.standard.set(conditionValues, forKey: "userSkinConditions")
        
        let skinAnalysisVC = SkinAnalysisViewController()
        navigationController?.pushViewController(skinAnalysisVC, animated: true)
    }
    
    // MARK: - Helper Methods
    private func loadExistingData() {
        if let savedConditions = UserDefaults.standard.array(forKey: "userSkinConditions") as? [String] {
            selectedConditions = Set(savedConditions)
            
            for rowStack in gridStackView.arrangedSubviews {
                if let rowStack = rowStack as? UIStackView {
                    for button in rowStack.arrangedSubviews {
                        if let button = button as? UIButton,
                           let condition = SkinCondition(rawValue: button.tag),
                           selectedConditions.contains(condition.title) {
                            button.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0.2)
                            button.layer.borderColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0).cgColor
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conditions.count
    }
    
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConditionCell", for: indexPath)
        let condition = conditions[indexPath.row]
        
        cell.textLabel?.text = condition
        cell.accessoryType = selectedConditions.contains(condition) ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let condition = conditions[indexPath.row]
        
        if condition == "Diğer" {
            customConditionTextField.isHidden = false
            if !customCondition.isEmpty {
                selectedConditions.insert(customCondition)
            }
        } else {
            if selectedConditions.contains(condition) {
                selectedConditions.remove(condition)
            } else {
                selectedConditions.insert(condition)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        saveSelectedConditions()
    }
    
    private func saveSelectedConditions() {
        var conditionsToSave = selectedConditions
        if !customCondition.isEmpty {
            conditionsToSave.insert(customCondition)
        }
        UserDefaults.standard.set(Array(conditionsToSave), forKey: "userSkinConditions")
    }
    
    @objc private func customConditionTextFieldDidChange(_ textField: UITextField) {
        customCondition = textField.text ?? ""
        if !customCondition.isEmpty {
            selectedConditions.insert(customCondition)
        }
        saveSelectedConditions()
    }
}


