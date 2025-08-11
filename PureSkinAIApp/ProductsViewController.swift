import UIKit
import SnapKit

class ProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundcolor
        setupNavigationTitle()
        setupTableView()
    }

    private func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center

        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.label
        ]
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .regular),
            .foregroundColor: UIColor.label
        ]

        let attributedText = NSMutableAttributedString(string: "Pure", attributes: boldAttributes)
        attributedText.append(NSAttributedString(string: "Skin", attributes: normalAttributes))

        titleLabel.attributedText = attributedText
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundcolor

        tableView.register(SelfiePromptCell.self, forCellReuseIdentifier: SelfiePromptCell.identifier)

        let headerImageView = UIImageView()
        headerImageView.image = UIImage(named: "homeimage")
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true

        let headerHeight: CGFloat = 220
        headerImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight)

        tableView.tableHeaderView = headerImageView

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelfiePromptCell.identifier, for: indexPath) as! SelfiePromptCell
        cell.selectionStyle = .none
        cell.onAddSelfieTapped = { [weak self] in
            self?.openCustomCamera()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

    // MARK: Yeni fonksiyon
    private func openCustomCamera() {
        let cameraVC = CustomCameraViewController()
        cameraVC.modalPresentationStyle = .fullScreen
        present(cameraVC, animated: true)
    }
}
