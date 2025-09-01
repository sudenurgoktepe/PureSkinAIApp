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
    private let addToRoutineButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ürün Ekle"
        view.backgroundColor = .systemBackground
        setupUI()
        setupKeyboardObservers()
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
        
        addPhotoButton.setTitle("📷 Fotoğraf Ekle", for: .normal)
        addPhotoButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addPhotoButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        
        nameTextField.placeholder = "Ürün Adı"
        nameTextField.borderStyle = .roundedRect
        nameTextField.delegate = self
        
        categoryTextField.placeholder = "Kategori (ör: Göz Kremi)"
        categoryTextField.borderStyle = .roundedRect
        categoryTextField.delegate = self
        
        addToRoutineButton.setTitle("Rutine Ekle", for: .normal)
        addToRoutineButton.backgroundColor = .systemGreen
        addToRoutineButton.setTitleColor(.white, for: .normal)
        addToRoutineButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        addToRoutineButton.layer.cornerRadius = 12
        
   
        let stack = UIStackView(arrangedSubviews: [
            productImageView, addPhotoButton,
            nameTextField, categoryTextField,
            addToRoutineButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        contentView.addSubview(stack)
        
        productImageView.snp.makeConstraints { $0.height.equalTo(220) }
        addToRoutineButton.snp.makeConstraints { $0.height.equalTo(50) }
        
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
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                picker.cameraDevice = .rear
            }
        } else {
            picker.sourceType = .photoLibrary
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.present(picker, animated: true)
        }
    }
    
    // MARK: - Fotoğraf Seçimi
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        
        if let image = info[.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[.originalImage] as? UIImage {
            selectedImage = image
        }
        
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
}
