//
//  AnalysisViewController.swift
//  PureSkinAIApp
//
//  Created by sude on 9.07.2025.
//

import UIKit
import SnapKit

class AnalysisViewController: UIViewController {
    private let resultText: String
    private let image: UIImage
    private let imageView = UIImageView()
    private let resultTextView = UITextView()

    init(resultText: String, image: UIImage) {
        self.resultText = resultText
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(resultTextView)

        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true

        resultTextView.font = UIFont.systemFont(ofSize: 16)
        resultTextView.isEditable = false
        resultTextView.text = resultText

        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(view.snp.width)
        }
    }
}
