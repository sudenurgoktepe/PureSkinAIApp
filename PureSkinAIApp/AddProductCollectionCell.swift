

import UIKit
import SnapKit

final class AddProductCollectionCell: UICollectionViewCell {
    static let identifier = "AddProductCollectionCell"
    
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 14
        contentView.backgroundColor = .backgroundcolor
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGreen.cgColor
        contentView.clipsToBounds = true
        
        iconView.image = UIImage(named: "skinProduct")
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemGreen
        
        titleLabel.text = "Ürün Ekle"
        titleLabel.textColor = .systemGreen
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textAlignment = .center
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(titleLabel)
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { $0.center.equalToSuperview() }
        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(50) 
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
