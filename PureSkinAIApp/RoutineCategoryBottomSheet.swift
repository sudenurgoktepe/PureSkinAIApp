import UIKit

class RoutineCategoryBottomSheet: UIViewController {

    var onCategorySelected: ((String) -> Void)?

    private let categories = ["Temizleme", "Toner/Spray", "Tedavi", "Nemlendirici", "Koruma", "Diğer"]

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sabah Rutinine Ekle"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    private let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundcolor
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundcolor
        view.layer.cornerRadius = 20
        view.clipsToBounds = true

        setupUI()
    }

    private func setupUI() {
        view.addSubview(handleView)
        view.addSubview(titleLabel)
        view.addSubview(tableView)

        handleView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            handleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 40),
            handleView.heightAnchor.constraint(equalToConstant: 6),

            titleLabel.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
    }
}

extension RoutineCategoryBottomSheet: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCategorySelected?(categories[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
