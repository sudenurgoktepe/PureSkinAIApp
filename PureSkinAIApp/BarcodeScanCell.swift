//
//  BarcodeScanCell.swift
//  PureSkinAIApp
//
//  Created by sude on 17.08.2025.
//

import UIKit
import SnapKit

class BarcodeScanCell: UITableViewCell {

    static let identifier = "BarcodeScanCell"
    var onScanTapped: (() -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Barkod Tara"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundcolor2
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        return view
    }()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "barcode.viewfinder")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        return imageView
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Fotoğraf ya da barkod ile tara"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let tapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(cardView)
        cardView.addSubview(iconView)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(tapButton)

        // Başlık
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        // Kart
        cardView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
            make.bottom.equalToSuperview().inset(20)
        }

        // İkon
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(24)
        }

        // Alt yazı
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        // Tüm karta tıklama
        tapButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tapButton.addTarget(self, action: #selector(scanTapped), for: .touchUpInside)
    }

    @objc private func scanTapped() {
        onScanTapped?()
    }
}
