import UIKit
import SnapKit

protocol CollectionTableViewCellDelegate: AnyObject {
    func didSelectItem(_ item: String)
}

class CollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var items: [String] = []
    weak var delegate: CollectionTableViewCellDelegate?

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "itemCell")
        cv.backgroundColor = .backgroundcolor
        return cv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .backgroundcolor
        contentView.backgroundColor = .backgroundcolor

        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with items: [String]) {
        self.items = items
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath)

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.backgroundColor = .cellBackground
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.05
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowRadius = 3
        cell.layer.masksToBounds = false

        let label = UILabel()
        label.text = items[indexPath.item]
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false

        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
             let itemsPerRow: CGFloat = 2
             let spacing: CGFloat = 8
             let totalSpacing = spacing * (itemsPerRow - 1)
             let availableWidth = collectionView.bounds.width - totalSpacing
             let width = floor(availableWidth / itemsPerRow)
             return CGSize(width: width, height: 50)
         }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(items[indexPath.item])
    }
}
