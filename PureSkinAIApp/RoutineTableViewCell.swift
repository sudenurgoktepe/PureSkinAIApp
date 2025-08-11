import UIKit

class RoutineTableViewCell: UITableViewCell {
    static let identifier = "RoutineTableViewCell"
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let circleView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true

        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.backgroundColor = .backgroundcolor2

        let padding: CGFloat = 12
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: padding / 2, left: 16, bottom: padding / 2, right: 16))
    }

    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(circleView)
        circleView.addSubview(checkmarkImageView)

        iconImageView.tintColor = .systemYellow
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }

        circleView.layer.cornerRadius = 12
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.systemGray3.cgColor
        circleView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }

        checkmarkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(14)
        }

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 1
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(circleView.snp.leading).offset(-8)
        }

        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.numberOfLines = 1
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.lessThanOrEqualTo(circleView.snp.leading).offset(-8)
            make.bottom.lessThanOrEqualToSuperview().inset(12).priority(.medium)
        }
    }


    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    func configure(with step: RoutineStep) {
        iconImageView.image = UIImage(named: step.iconName)
        subtitleLabel.text = step.subtitle.isEmpty ? "Bu rutin için ürün seçilmedi" : step.subtitle

        if step.isCompleted {
            titleLabel.textColor = .systemGray
            subtitleLabel.textColor = .systemGray3
            contentView.alpha = 0.5

            let attributeString = NSMutableAttributedString(string: step.title)
            attributeString.addAttribute(.strikethroughStyle,
                                         value: NSUnderlineStyle.single.rawValue,
                                         range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString

            circleView.backgroundColor = .systemGreen
            checkmarkImageView.isHidden = false
        } else {
            titleLabel.textColor = .label
            subtitleLabel.textColor = .systemGray
            contentView.alpha = 1.0
            titleLabel.attributedText = nil
            titleLabel.text = step.title

            circleView.backgroundColor = .clear
            checkmarkImageView.isHidden = true
        }
    }
}
