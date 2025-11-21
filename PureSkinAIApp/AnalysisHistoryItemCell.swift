import UIKit
import SnapKit

class AnalysisHistoryItemCell: UICollectionViewCell {
    static let identifier = "AnalysisHistoryItemCell"
    
    private let imageView = UIImageView()
    private let scoreContainer = UIView()
    private let scoreLabel = UILabel()
    private let deleteButton = UIButton(type: .system)
    
    var onDeleteTapped: (() -> Void)?
    
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
        
        scoreContainer.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
        scoreContainer.layer.cornerRadius = 8
        
        scoreLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        scoreLabel.textColor = UIColor(red: 0.93, green: 0.67, blue: 0.55, alpha: 1.0)
        scoreLabel.textAlignment = .center
        
        deleteButton.setImage(UIImage(systemName: "trash.circle.fill"), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        
        contentView.addSubview(imageView)
        contentView.addSubview(scoreContainer)
        contentView.addSubview(deleteButton)
        scoreContainer.addSubview(scoreLabel)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(110)
        }
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(26)
        }
        scoreContainer.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(34)
        }
        scoreLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with analysis: SkinAnalysis) {
        imageView.image = UIImage(data: analysis.imageData)
        scoreLabel.text = "Skor: \(analysis.score)"
    }
    
    @objc private func deletePressed() {
        onDeleteTapped?()
    }
}
