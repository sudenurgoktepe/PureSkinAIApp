//
//  AddProductCell.swift
//  PureSkinAIApp
//
//  Created by sude on 25.08.2025.
//

import UIKit
import SnapKit

class AddProductCell: UITableViewCell {
    static let identifier = "AddProductCell"
    
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        // Container (orta kutu)
        containerView.backgroundColor = .backgroundcolor
        containerView.layer.cornerRadius = 14
        containerView.layer.borderWidth = 1.5
        containerView.layer.borderColor = UIColor.systemGreen.cgColor
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // Icon
        iconImageView.image = UIImage(named: "skinProduct")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemGreen
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        
        // Title label
        titleLabel.text = "Ürün Ekle"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemGreen
        
        // Subtitle label
        subtitleLabel.text = "Evdeki ürünlerinizi günlük rutininize ekleyin"
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2
        
        // Stack
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
