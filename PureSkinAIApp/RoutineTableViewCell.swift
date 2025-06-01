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

        contentView.backgroundColor = .backgroundcolor

      
        let padding: CGFloat = 12
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: padding / 2, left: 16, bottom: padding / 2, right: 16))
    }

    private func setupViews() {
        iconImageView.tintColor = .systemYellow
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)

        circleView.layer.borderColor = UIColor.systemGray3.cgColor
        circleView.layer.borderWidth = 1
        circleView.layer.cornerRadius = 12
        circleView.clipsToBounds = true 
        circleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(circleView)

        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.tintColor = .white
        checkmarkImageView.isHidden = true
        checkmarkImageView.contentMode = .scaleAspectFit
        circleView.addSubview(checkmarkImageView)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: circleView.leadingAnchor, constant: -12),

            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            circleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 24),
            circleView.heightAnchor.constraint(equalToConstant: 24),

    
            checkmarkImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 14),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
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
        subtitleLabel.text = step.subtitle

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
