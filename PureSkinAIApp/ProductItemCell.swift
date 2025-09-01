

import UIKit
import SnapKit

class ProductItemCell: UICollectionViewCell {
    static let identifier = "ProductItemCell"
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 14
        contentView.backgroundColor = .systemBackground
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 6
        contentView.layer.masksToBounds = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        nameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 2
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(150)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with product: SavedProduct) {
        imageView.image = UIImage(data: product.imageData)
        nameLabel.text = product.name
    }
}
