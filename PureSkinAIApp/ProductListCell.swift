

import UIKit
import SnapKit

final class ProductListCell: UITableViewCell {
    static let identifier = "ProductListCell"
    
    private let collectionView: UICollectionView
    private var products: [SavedProduct] = []
    
    var onAddTapped: (() -> Void)?
    var onDeleteProduct: ((SavedProduct) -> Void)?
    var onProductTapped: ((SavedProduct) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130, height: 200)
        layout.minimumLineSpacing = 12
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = .clear
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ProductItemCell.self, forCellWithReuseIdentifier: ProductItemCell.identifier)
        collectionView.register(AddProductCollectionCell.self, forCellWithReuseIdentifier: AddProductCollectionCell.identifier)
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with products: [SavedProduct]) {
        self.products = products
        collectionView.reloadData()
    }
}

extension ProductListCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AddProductCollectionCell.identifier,
                for: indexPath
            ) as! AddProductCollectionCell
            return cell
        } else {
            let product = products[indexPath.item - 1]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductItemCell.identifier,
                for: indexPath
            ) as! ProductItemCell
            cell.configure(with: product)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            onAddTapped?()
        } else {
            let product = products[indexPath.item - 1]
            onProductTapped?(product) 
        }
    }
}

// MARK: - Helper
private extension UIView {
    func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while let responder = nextResponder {
            if let vc = responder as? UIViewController {
                return vc
            }
            nextResponder = responder.next
        }
        return nil
    }
}
