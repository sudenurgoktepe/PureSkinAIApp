import UIKit

class BottomSheetViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var options: [String] = []
    var onSelect: ((String) -> Void)?
    var selectedOption: String?

    private let dimmedView = UIView()
    private let sheetView = UIView()
    private var collectionView: UICollectionView!
    
    private var selectedIndex: Int?
    
    private var sheetHeight: CGFloat {
        let itemHeight: CGFloat = 50
        let spacing: CGFloat = 15
        let topBottomInset: CGFloat = 40
        let totalHeight = CGFloat(options.count) * (itemHeight + spacing) + topBottomInset
        return min(totalHeight, 400)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
        setupDimmedView()
        setupSheetView()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0
        sheetView.frame.origin.y = view.bounds.height
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateSheetIn()
    }

    
    private func setupDimmedView() {
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmedView.alpha = 0
        view.addSubview(dimmedView)
        dimmedView.frame = view.bounds
        dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSheet)))
    }
    
    private func addDragIndicator() {
        let indicator = UIView()
        indicator.backgroundColor = UIColor.systemGray3
        indicator.layer.cornerRadius = 3
        indicator.translatesAutoresizingMaskIntoConstraints = false
        sheetView.addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 8),
            indicator.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 40),
            indicator.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    private func setupSheetView() {
        sheetView.backgroundColor = .systemBackground
        sheetView.layer.cornerRadius = 16
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(sheetView)
        sheetView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: sheetHeight)
        addDragIndicator()

    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 60, height: 60)
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OptionCell.self, forCellWithReuseIdentifier: "OptionCell")
        
        sheetView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: sheetView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor)
        ])
    }
    
    private func animateSheetIn() {
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1
            self.dimmedView.alpha = 1
            self.sheetView.frame.origin.y = self.view.bounds.height - self.sheetHeight
        }
    }

    @objc private func dismissSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmedView.alpha = 0
            self.sheetView.frame.origin.y = self.view.bounds.height
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if gesture.state == .changed && translation.y > 0 {
            sheetView.frame.origin.y = (view.frame.height - sheetHeight) + translation.y
        } else if gesture.state == .ended || gesture.state == .cancelled {
            if translation.y > 100 {
                dismissSheet()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.sheetView.frame.origin.y = self.view.frame.height - self.sheetHeight
                }
            }
        }
    }

    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath)

        let isSelectedOption = options[indexPath.item] == selectedOption

        // Önceki alt görünümleri temizle
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let label = UILabel()
        label.text = options[indexPath.item]
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.layer.cornerRadius = 10
        label.layer.borderWidth = isSelectedOption ? 2 : 0
        label.layer.borderColor = isSelectedOption ? UIColor.systemGreen.cgColor : UIColor.clear.cgColor
        label.layer.masksToBounds = true
        label.textColor = .label
        label.backgroundColor = .secondarySystemBackground
        label.translatesAutoresizingMaskIntoConstraints = false

        cell.contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
        ])

        if isSelectedOption {
            let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
            checkmark.tintColor = .systemGreen
            checkmark.translatesAutoresizingMaskIntoConstraints = false
            label.addSubview(checkmark)

            NSLayoutConstraint.activate([
                checkmark.topAnchor.constraint(equalTo: label.topAnchor, constant: 4),
                checkmark.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -4),
                checkmark.widthAnchor.constraint(equalToConstant: 20),
                checkmark.heightAnchor.constraint(equalToConstant: 20)
            ])
        }

        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.onSelect?(self.options[indexPath.item])
            self.dismissSheet()
        }
    }
}

// MARK: - Custom Cell
class OptionCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    private let checkmark = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.backgroundColor = .secondarySystemBackground
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.image = UIImage(systemName: "checkmark.circle.fill")
        checkmark.tintColor = .systemGreen
        checkmark.isHidden = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmark)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            checkmark.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            checkmark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            checkmark.widthAnchor.constraint(equalToConstant: 20),
            checkmark.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        contentView.layer.borderColor = isSelected ? UIColor.systemGreen.cgColor : UIColor.clear.cgColor
        checkmark.isHidden = !isSelected
    }
}
