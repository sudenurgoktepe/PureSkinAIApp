//
//  AddProductViewController.swift
//  PureSkinAIApp
//
//  Created by sude on 22.08.2025.
//

import UIKit
import SnapKit

final class AddProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let productImageView = UIImageView()
    private let addPhotoButton = UIButton(type: .system)
    private let nameTextField = UITextField()
    private let categoryTextField = UITextField()
    private let descriptionTextField = UITextField()
    
    private let routineOptionButton = UIButton(type: .system)
    private var shouldAddToRoutine = false
    
    private let addProductButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ürün Ekle"
        view.backgroundColor = .systemBackground
        setupUI()
        setupKeyboardObservers()
        setupCustomBackButton()
    }
    // MARK: - Özel Back Button
    private func setupCustomBackButton() {
        let backImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIButton(type: .system)
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .black
        backButton.setTitle(" Geri", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        productImageView.image = UIImage(named: "addProductImage")
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 16
        productImageView.backgroundColor = UIColor.secondarySystemBackground
        
        addPhotoButton.setTitle("Fotoğraf Ekle", for: .normal)
        addPhotoButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addPhotoButton.setTitleColor(UIColor.systemPink, for: .normal)
        addPhotoButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        
        nameTextField.placeholder = "Ürün Adı"
        nameTextField.borderStyle = .roundedRect
        nameTextField.delegate = self
        
        categoryTextField.placeholder = "Kategori (ör: Göz Kremi)"
        categoryTextField.borderStyle = .roundedRect
        categoryTextField.delegate = self
        
        descriptionTextField.placeholder = "Açıklama (isteğe bağlı)"
        descriptionTextField.borderStyle = .roundedRect
        descriptionTextField.delegate = self
        
        routineOptionButton.setTitle("  Rutinime ekle", for: .normal)
        routineOptionButton.setTitleColor(.label, for: .normal)
        routineOptionButton.setImage(UIImage(systemName: "circle"), for: .normal)
        routineOptionButton.tintColor = .systemGreen
        routineOptionButton.contentHorizontalAlignment = .leading
        routineOptionButton.addTarget(self, action: #selector(toggleRoutineOption), for: .touchUpInside)
        
        addProductButton.setTitle("Ürün Ekle", for: .normal)
        addProductButton.backgroundColor = .systemGreen
        addProductButton.setTitleColor(.white, for: .normal)
        addProductButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        addProductButton.layer.cornerRadius = 12
        addProductButton.addTarget(self, action: #selector(addProductTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            productImageView, addPhotoButton,
            nameTextField, categoryTextField, descriptionTextField,
            routineOptionButton,
            addProductButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        contentView.addSubview(stack)
        
        productImageView.snp.makeConstraints { $0.height.equalTo(350) }
        addProductButton.snp.makeConstraints { $0.height.equalTo(50) }
        
        stack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    // MARK: - Kamera Açma
    @objc private func openCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        if picker.sourceType == .camera, UIImagePickerController.isCameraDeviceAvailable(.rear) {
            picker.cameraDevice = .rear
        }
        present(picker, animated: true)
    }
    
    // MARK: - Fotoğraf Seçimi
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        if let image = selectedImage {
            productImageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    // MARK: - Klavye Yönetimi
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            scrollView.contentInset.bottom = keyboardFrame.height + 20
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: -  Rutinime ekle seçeneği
    @objc private func toggleRoutineOption() {
        shouldAddToRoutine.toggle()
        let icon = shouldAddToRoutine ? "checkmark.circle.fill" : "circle"
        routineOptionButton.setImage(UIImage(systemName: icon), for: .normal)
    }
    
    // MARK: -  Ürün Kaydetme
    @objc private func addProductTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let category = categoryTextField.text, !category.isEmpty,
              let image = productImageView.image,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            
            validateFields()
            return
        }
        
        let description = descriptionTextField.text ?? ""
        let newProduct = SavedProduct(
            id: UUID(),
            name: name,
            imageData: imageData,
            category: category,
            descriptionText: descriptionTextField.text,
            isInRoutine: shouldAddToRoutine
        )
        ProductStore.save(newProduct)
    
        if shouldAddToRoutine {
            CategoryStore.addProduct(category: category, product: name)
            if !description.isEmpty {
                var dict = UserDefaults.standard.dictionary(forKey: "productDescriptions") as? [String: String] ?? [:]
                dict[name] = description
                UserDefaults.standard.set(dict, forKey: "productDescriptions")
            }
            NotificationCenter.default.post(name: Notification.Name("CategoryUpdated"), object: nil)
        }
        
        navigationController?.popViewController(animated: true)
    }
    private func validateFields() {
        [nameTextField, categoryTextField].forEach { tf in
            if let text = tf.text, text.isEmpty {
                tf.layer.borderColor = UIColor.systemRed.cgColor
                tf.layer.borderWidth = 1
            } else {
                tf.layer.borderColor = UIColor.clear.cgColor
                tf.layer.borderWidth = 0
            }
        }
    }
}
