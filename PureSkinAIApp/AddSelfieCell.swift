//
//  AddSelfieCell.swift
//  PureSkinAIApp
//
//  Created by sude on 18.08.2025.
//

//
//  AddSelfieCell.swift
//  PureSkinAIApp
//
//  Created by sude on 18.08.2025.
//

import Foundation
import UIKit
import SnapKit

class AddSelfieCell: UICollectionViewCell {
    static let identifier = "AddSelfieCell"
    
    private let plusLabel = UILabel()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .backgroundcolor
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemGray4.cgColor  // kenar çizgisi
        
        // Plus label
        plusLabel.text = "+"
        plusLabel.font = .systemFont(ofSize: 40, weight: .bold)
        plusLabel.textAlignment = .center
        plusLabel.textColor = .label
        
        // Title label
        titleLabel.text = "Selfie Ekle"
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .secondaryLabel
        
        // Stack
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        stackView.addArrangedSubview(plusLabel)
        stackView.addArrangedSubview(titleLabel)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
