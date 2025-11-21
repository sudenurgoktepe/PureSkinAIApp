//
//  EmptyAnalysisView.swift
//  PureSkinAIApp
//
//  Created by sude on 18.08.2025.
//
import UIKit

class EmptyAnalysisView: UIView {
    let addButton = UIButton(type: .system)
    private let infoLabel = UILabel()
    private let dashedBorder = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        dashedBorder.strokeColor = UIColor.systemGray3.cgColor
        dashedBorder.lineDashPattern = [6, 4]
        dashedBorder.fillColor = UIColor.clear.cgColor
        dashedBorder.lineWidth = 1.2
        layer.addSublayer(dashedBorder)
        
        let plusImage = UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal)
        addButton.setImage(plusImage, for: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.backgroundColor = .clear
        addButton.layer.cornerRadius = 20
        addButton.clipsToBounds = true
        
        infoLabel.text = "Cilt ilerlemenizi düzenli olarak takip etmek için buradan selfie ekleyebilirsiniz. Unutmayın, cildiniz bizim için çok önemli!"
        infoLabel.font = .systemFont(ofSize: 15, weight: .medium)
        infoLabel.textColor = .secondaryLabel
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        
        addSubview(addButton)
        addSubview(infoLabel)
        
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(32)
            make.width.height.equalTo(50) // buton boyutu
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(14)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashedBorder.frame = bounds
        dashedBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
