
import UIKit
import SnapKit

final class ProductDetailViewController: UIViewController {
    private var product: SavedProduct
    private var isInRoutine: Bool
    
    private let productImageView = UIImageView()
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let routineCheckButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)

    init(product: SavedProduct) {
        self.product = product
        
        var inRoutine = false
        
        if let data = UserDefaults.standard.data(forKey: "dynamicRoutines"),
           let decoded = try? JSONDecoder().decode([SavedRoutine].self, from: data) {
            inRoutine = decoded.contains { $0.name == product.name }
        }
        
        if !inRoutine, let category = product.category {
            let categories = CategoryStore.load()
            if let items = categories[category], items.contains(product.name) {
                inRoutine = true
            }
        }
        
        self.isInRoutine = inRoutine
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Ürün Detayı"
        setupNavigationBar()
        setupUI()
    }
    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = .black
        backButton.setTitle(" Geri", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }


    private func setupUI() {
        if let image = UIImage(data: product.imageData) {
            productImageView.image = image
        } else {
            productImageView.image = UIImage(named: "addProductImage")
        }
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 12
        productImageView.snp.makeConstraints { $0.height.equalTo(350) }

        nameLabel.text = product.name
        nameLabel.font = .boldSystemFont(ofSize: 20)

        categoryLabel.text = "Kategori: \(product.category ?? "Bilinmiyor")"
        categoryLabel.font = .systemFont(ofSize: 16)
        categoryLabel.textColor = .darkGray

        descriptionLabel.text = product.descriptionText ?? "Açıklaması yok"
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0

        routineCheckButton.setTitle("Rutinim", for: .normal)
        routineCheckButton.setTitleColor(.label, for: .normal)
        routineCheckButton.setImage(UIImage(systemName: isInRoutine ? "checkmark.circle.fill" : "circle"), for: .normal)
        routineCheckButton.tintColor = .systemGreen
        routineCheckButton.contentHorizontalAlignment = .left
        routineCheckButton.addTarget(self, action: #selector(toggleRoutine), for: .touchUpInside)

        saveButton.setTitle("Değişiklikleri Kaydet", for: .normal)
        saveButton.backgroundColor = .systemGreen
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        saveButton.snp.makeConstraints { $0.height.equalTo(50) }

        deleteButton.setTitle("Ürünü Sil", for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.layer.cornerRadius = 10
        deleteButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        deleteButton.addTarget(self, action: #selector(deleteProduct), for: .touchUpInside)
        deleteButton.snp.makeConstraints { $0.height.equalTo(50) }

        let stack = UIStackView(arrangedSubviews: [
            productImageView, nameLabel, categoryLabel,
            descriptionLabel, routineCheckButton,
            saveButton, deleteButton
        ])
        stack.axis = .vertical
        stack.spacing = 16

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    @objc private func toggleRoutine() {
        isInRoutine.toggle()
        let icon = isInRoutine ? "checkmark.circle.fill" : "circle"
        routineCheckButton.setImage(UIImage(systemName: icon), for: .normal)
    }

    @objc private func saveChanges() {
        var routines: [SavedRoutine] = []
        if let data = UserDefaults.standard.data(forKey: "dynamicRoutines"),
           let decoded = try? JSONDecoder().decode([SavedRoutine].self, from: data) {
            routines = decoded
        }

        if isInRoutine {
            if !routines.contains(where: { $0.name == product.name }) {
                let newRoutine = SavedRoutine(name: product.name, type: "sabah", days: [])
                routines.append(newRoutine)
                if let category = product.category {
                    CategoryStore.addProduct(category: category, product: product.name)
                }
            }
        } else {
            routines.removeAll { $0.name == product.name }
            if let category = product.category {
                var categories = CategoryStore.load()
                if var items = categories[category] {
                    items.removeAll { $0 == product.name }
                    if items.isEmpty { categories.removeValue(forKey: category) }
                    else { categories[category] = items }
                    CategoryStore.save(categories)
                }
            }
        }

        if let encoded = try? JSONEncoder().encode(routines) {
            UserDefaults.standard.set(encoded, forKey: "dynamicRoutines")
        }

        navigationController?.popViewController(animated: true)
    }

    @objc private func deleteProduct() {
        let alert = UIAlertController(
            title: "Ürünü Sil",
            message: "Bu ürünü silmek istediğinize emin misiniz?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Evet", style: .destructive, handler: { _ in
            ProductStore.delete(self.product)
            if let category = self.product.category {
                var categories = CategoryStore.load()
                if var items = categories[category] {
                    items.removeAll { $0 == self.product.name }
                    if items.isEmpty { categories.removeValue(forKey: category) }
                    else { categories[category] = items }
                    CategoryStore.save(categories)
                }
            }
            if let data = UserDefaults.standard.data(forKey: "dynamicRoutines"),
               var routines = try? JSONDecoder().decode([SavedRoutine].self, from: data) {
                routines.removeAll { $0.name == self.product.name }
                if let encoded = try? JSONEncoder().encode(routines) {
                    UserDefaults.standard.set(encoded, forKey: "dynamicRoutines")
                }
            }
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
