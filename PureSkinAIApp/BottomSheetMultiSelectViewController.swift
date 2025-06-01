import UIKit

class BottomSheetMultiSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var options: [String] = []
    var selectedOptions: Set<String> = []
    var onDone: (([String]) -> Void)?

    private let dimmedView = UIView()
    private let sheetView = UIView()
    private var collectionView: UICollectionView!

    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tamam", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var sheetHeight: CGFloat = 400
    private var sheetPanStartTopConstant: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        sheetHeight = CGFloat(min(70 * options.count + 80, 450))

        setupDimmedView()
        setupSheetView()
        setupCollectionView()
        setupDoneButton()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(panGesture)
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

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        dimmedView.addGestureRecognizer(tap)
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
        sheetView.clipsToBounds = true
        view.addSubview(sheetView)
        addDragIndicator()
        sheetView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: sheetHeight)
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 60, height: 60)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        sheetView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: sheetView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor, constant: -60)
        ])
    }

    private func setupDoneButton() {
        sheetView.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor, constant: -10),
            doneButton.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 100),
            doneButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
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
            self.dismiss(animated: false)
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        switch gesture.state {
        case .began:
            sheetPanStartTopConstant = sheetView.frame.origin.y
        case .changed:
            if translation.y > 0 {
                sheetView.frame.origin.y = sheetPanStartTopConstant + translation.y
            }
        case .ended:
            if translation.y > 100 {
                dismissSheet()
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.sheetView.frame.origin.y = self.view.bounds.height - self.sheetHeight
                }
            }
        default:
            break
        }
    }

    @objc private func doneButtonTapped() {
        onDone?(Array(selectedOptions))
        dismissSheet()
    }

    // MARK: - CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let title = options[indexPath.item]
        let isSelected = selectedOptions.contains(title)

        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.backgroundColor = .secondarySystemBackground
        label.layer.cornerRadius = 10
        label.layer.borderWidth = isSelected ? 2 : 0
        label.layer.borderColor = isSelected ? UIColor.systemGreen.cgColor : UIColor.clear.cgColor
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false

        // Tik ikonu
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmark.tintColor = .systemGreen
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.isHidden = !isSelected

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(label)
        label.addSubview(checkmark)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),

            checkmark.topAnchor.constraint(equalTo: label.topAnchor, constant: 5),
            checkmark.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -5),
            checkmark.widthAnchor.constraint(equalToConstant: 20),
            checkmark.heightAnchor.constraint(equalToConstant: 20),
        ])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = options[indexPath.item]
        if selectedOptions.contains(title) {
            selectedOptions.remove(title)
        } else {
            selectedOptions.insert(title)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}
