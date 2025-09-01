import UIKit
import SnapKit

class ProductsViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundcolor
        setupNavigationTitle()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Navigation Title
    private func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        let bold: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.label
        ]
        let normal: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .regular),
            .foregroundColor: UIColor.label
        ]
        let attr = NSMutableAttributedString(string: "Pure", attributes: bold)
        attr.append(NSAttributedString(string: "Skin", attributes: normal))
        titleLabel.attributedText = attr
        navigationItem.titleView = titleLabel
    }

    // MARK: - TableView Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundcolor
        
        tableView.register(AnalysisHistoryCell.self, forCellReuseIdentifier: AnalysisHistoryCell.identifier)
        tableView.register(ProductListCell.self, forCellReuseIdentifier: ProductListCell.identifier)

        let headerImageView = UIImageView()
        headerImageView.image = UIImage(named: "homeimage")
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 220)
        tableView.tableHeaderView = headerImageView

        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
}

// MARK: - UITableViewDelegate & DataSource
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let data = SkinAnalysisStore.load()
            
            if data.isEmpty {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "EmptyCell")
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                
                let emptyView = EmptyAnalysisView()
                emptyView.addButton.addTarget(self, action: #selector(openCustomCameraFromButton), for: .touchUpInside)
                
                cell.contentView.addSubview(emptyView)
                emptyView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(16)
                    make.top.bottom.equalToSuperview().inset(8)
                    make.height.greaterThanOrEqualTo(80)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: AnalysisHistoryCell.identifier,
                    for: indexPath
                ) as! AnalysisHistoryCell
                cell.selectionStyle = .none
                cell.configure(with: data)
                
                cell.onAddTapped = { [weak self] in self?.openCustomCamera() }
                cell.onSelectAnalysis = { [weak self] analysis in
                    guard let img = UIImage(data: analysis.imageData) else { return }
                    let vc = AnalysisViewController(resultText: analysis.resultText, image: img)
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                }
                cell.onDeleteAnalysis = { [weak self] analysis, indexPath in
                    guard let self = self else { return }
                    let alert = UIAlertController(
                        title: "Emin misiniz?",
                        message: "Bu analizi silmek istiyor musunuz?",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
                    alert.addAction(UIAlertAction(title: "Sil", style: .destructive, handler: { _ in
                        SkinAnalysisStore.delete(analysis)
                        tableView.reloadData()
                    }))
                    self.present(alert, animated: true)
                }
                return cell
            }
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.identifier, for: indexPath) as! ProductListCell
            let products = ProductStore.load()
            cell.configure(with: products)
        
            cell.onAddTapped = { [weak self] in
                let vc = AddProductViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.onDeleteProduct = { product in
                ProductStore.delete(product)
                tableView.reloadData()
            }
        
            cell.onProductTapped = { [weak self] product in
                let detailVC = ProductDetailViewController(product: product)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView()
        container.backgroundColor = .clear
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.text = section == 0 ? "Cilt Analizi Geçmişi" : "Ürünlerim"
        
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(6)
        }
        
        return container
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

// MARK: - Actions
extension ProductsViewController {
    private func openCustomCamera() {
        let vc = CustomCameraViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func openCustomCameraFromButton() {
        openCustomCamera()
    }
}
