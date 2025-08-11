
import UIKit
import SnapKit

var selectedDate: Date = Date()
class RoutineCategoryBottomSheet: UIViewController {

    private let categories = ["Temizleme", "Toner/Spray", "Tedavi", "Nemlendirici", "Koruma", "Diğer"]
    var isMorningRoutine: Bool = true
    var selectedDate: Date = Date()
    private var expandedSection: Int? = nil
    private var dayButtons: [UIButton] = []
    private var addButton: UIButton?
    private var selectedItemName: String?

    private let itemsByCategory: [String: [String]] = [
        "Temizleme": ["Yağ Bazlı Temizleme", "Su Bazlı Temizleme", "Misel Su ile Temizleme", "Nemlendirici Temizleyici Uygula", "Temizleme Sütü Uygula", "Temizleme Balmi Uygula", "Temizleme Kremi Uygula","Köpük Temizleyici"],
        "Toner/Spray": ["Hassas Tonik", "Nem Spreyi","Peeling Tonik(AHA/BHA)","Sıkılaştırıcı Tonik"],
        "Tedavi": ["Akne Karşıtı", "Leke Serumu","C Vitamini Serumu","Retinol","Hyaluronik Asit","Niacinamide","Sivilce Jeli","Leke Açıcı Serum","Göz Altı Serumu"],
        "Nemlendirici": ["Hafif Nemlendirici Jel", "Yoğun Nemlendirici Krem","Uyku Maskesi","Göz Kremi"],
        "Koruma": ["GKF 50+", "GKF 30+","SPF Stick"],
        "Diğer": ["Yüz Masajı", "Maske","Gua Sha"]
    ]
 
    private let itemDescriptions: [String: String] = [
        // Temizleme
        "Yağ Bazlı Temizleme": "Makyajı, güneş kremini ve fazla yağı etkili bir şekilde temizlerken cildin doğal nem bariyerini korur.",
        "Su Bazlı Temizleme": "Ciltte kalan yağ, kir ve su bazlı kalıntıları nazikçe temizler. Cildi ferahlatır ve arındırır.",
        "Misel Su ile Temizleme": "Durulama gerektirmeyen, cildi yormadan makyaj ve kiri temizleyen hafif yapılı bir temizleyicidir.",
        "Nemlendirici Temizleyici Uygula": "Cildi temizlerken aynı anda nemlendirici etkisi sunar. Özellikle kuru ciltler için uygundur.",
        "Temizleme Sütü Uygula": "Hassas ciltler için nazik bir temizlik sunar. Cildi yumuşatarak temizler.",
        "Temizleme Balmi Uygula": "Katı formda olup ciltle temas ettiğinde yağ haline gelir. Yoğun makyajı etkili şekilde çözer.",
        "Temizleme Kremi Uygula": "Yoğun yapılı, nemlendirici etkili temizleyici. Özellikle kuru ve hassas ciltler için önerilir.",
        "Köpük Temizleyici": "Hafif yapılı köpük formuyla gözenekleri derinlemesine temizlerken ferah bir his bırakır.",

        // Toner/Spray
        "Hassas Tonik": "Cildin pH dengesini korumaya yardımcı olur, hassas ciltler için uygundur.",
        "Nem Spreyi": "Cilde anında nem kazandırır ve ferahlık hissi verir. Gün içinde tekrar tekrar uygulanabilir.",
        "Peeling Tonik(AHA/BHA)": "AHA/BHA içeriğiyle gözenekleri temizlemeye ve cilt dokusunu yenilemeye yardımcı olur.",
        "Sıkılaştırıcı Tonik": "Gözenek görünümünü azaltarak cilde daha sıkı ve pürüzsüz bir görünüm kazandırır.",

        // Tedavi
        "Akne Karşıtı": "Sivilce oluşumunu azaltmaya yardımcı olur, gözenekleri temizler ve fazla sebumu dengeler.",
        "Leke Serumu": "Cilt tonunu eşitler ve güneş/yaşlılık lekelerini azaltmayı hedefler.",
        "C Vitamini Serumu": "Cilde aydınlık kazandırır, lekelerin görünümünü azaltmaya ve kolajen üretimini desteklemeye yardımcı olur.",
        "Retinol": "İnce çizgileri azaltmaya ve cilt yenilenmesini desteklemeye yardımcı güçlü bir anti-aging içeriktir.",
        "Hyaluronik Asit": "Cilde yoğun nem kazandırır, dolgun ve sağlıklı bir görünüm sağlar.",
        "Niacinamide": "Gözenek görünümünü azaltır, cilt tonunu eşitler ve cildin bariyerini güçlendirir.",
        "Sivilce Jeli": "Aktif sivilceleri hedef alarak kurutmaya ve iyileştirmeye yardımcı olur.",
        "Leke Açıcı Serum": "Ciltteki koyu lekelerin görünümünü azaltmaya ve cilt tonunu aydınlatmaya yardımcıdır.",
        "Göz Altı Serumu": "Göz altı morluklarını ve ince çizgileri azaltmaya yardımcı hafif yapılı bir serümdür.",

        // Nemlendirici
        "Hafif Nemlendirici Jel": "Yağlı ve karma ciltler için uygundur, gözenekleri tıkamadan hafif nemlendirme sağlar.",
        "Yoğun Nemlendirici Krem": "Kuru ciltler için zengin içerikli nemlendirme sağlar, cildi yumuşatır ve besler.",
        "Uyku Maskesi": "Gece boyunca cildi nemlendirir ve onarır, sabah yumuşak ve canlı bir ciltle uyanmanızı sağlar.",
        "Göz Kremi": "Göz çevresindeki hassas bölgeyi nemlendirir, morluk ve şişlik görünümünü azaltmaya yardımcı olur.",

        // Koruma
        "GKF 50+": "Yüksek güneş koruması sağlar. Güneşe çıkmadan 15 dakika önce uygulanmalıdır.",
        "GKF 30+": "Orta düzey güneş koruması sunar. Günlük kullanım için uygundur.",
        "SPF Stick": "Güneş korumasını gün içinde pratik bir şekilde tazelemek için kullanılır.",

        // Diğer
        "Yüz Masajı": "Kan dolaşımını artırır, cilde sağlıklı bir parlaklık kazandırır ve bakım ürünlerinin emilimini destekler.",
        "Maske": "Cilt tipine ve ihtiyacına uygun olarak nem, arındırma veya aydınlatma sağlar.",
        "Gua Sha": "Yüz masaj aletiyle yapılan masaj, lenf drenajını destekleyerek şişkinliği azaltır ve cilde canlılık kazandırır."
    ]

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sabah Rutinine Ekle"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var detailView: UIView?
    private var selectedDays = Set<String>() {
            didSet {
                updateAddButtonState()
            }
        }
    
    private func updateAddButtonState() {
           addButton?.isEnabled = !selectedDays.isEmpty
           addButton?.alpha = selectedDays.isEmpty ? 0.5 : 1.0
       }
    
    private func loadAllRoutines() -> [String: [String]] {
        let key = "userRoutines"
        let defaults = UserDefaults.standard
        let routines = defaults.dictionary(forKey: key) as? [String: [String]] ?? [:]
        return routines
    }
    
    private func loadSavedRoutines() -> [SavedRoutine] {
        guard let data = UserDefaults.standard.data(forKey: "dynamicRoutines"),
              let decoded = try? JSONDecoder().decode([SavedRoutine].self, from: data) else {
            return []
        }
        return decoded
    }
    
    private func routinesForToday() -> [String] {
        let allRoutines = loadAllRoutines()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "EEEE"
        let today = formatter.string(from: Date())

        return allRoutines.compactMap { (item, days) in
            days.contains(today) ? item : nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        titleLabel.text = isMorningRoutine ? "Sabah Rutinine Ekle" : "Akşam Rutinine Ekle"

    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundcolor
        view.layer.cornerRadius = 20
        view.clipsToBounds = true

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        view.addSubview(titleLabel)
        view.addSubview(tableView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "cell")
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "collectionCell")
    }
    
    private func showDetailView(for item: String) {
        detailView?.removeFromSuperview()
        selectedItemName = item
        selectedDays.removeAll()

        let detail = UIView()
        detail.backgroundColor = .backgroundcolor
        detail.layer.cornerRadius = 20
        view.addSubview(detail)
        detail.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }

        let title = UILabel()
        title.text = item
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.textColor = .gray
        title.textAlignment = .left

        let desc = UILabel()
        desc.text = itemDescriptions[item] ?? ""
        desc.numberOfLines = 0
        desc.font = UIFont.systemFont(ofSize: 14)
        desc.textColor = .darkGray
        desc.textAlignment = .left

        let subHeader = UILabel()
        subHeader.text = "Bu günler için ekle:"
        subHeader.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        subHeader.textColor = .black
        subHeader.textAlignment = .left

        let selectAllButton = UIButton(type: .system)
        selectAllButton.setTitle("📅 Tümünü Seç", for: .normal)
        selectAllButton.contentHorizontalAlignment = .left
        selectAllButton.setTitleColor(UIColor(red: 30/255, green: 130/255, blue: 76/255, alpha: 1.0), for: .normal)
        selectAllButton.addTarget(self, action: #selector(selectAllDays), for: .touchUpInside)

        let days = ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi", "Pazar"]
        var dayViews: [UIView] = []
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "EEEE"
        let defaultDay = formatter.string(from: selectedDate)
        selectedDays.insert(defaultDay)

        dayButtons.removeAll()

        for (index, day) in days.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(day, for: .normal)
            button.contentHorizontalAlignment = .left
            button.setTitleColor(.label, for: .normal)
            button.setImage(UIImage(systemName: "circle"), for: .normal)
            button.tintColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
            button.tag = index

            button.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                if self.selectedDays.contains(day) {
                    self.selectedDays.remove(day)
                    button.setImage(UIImage(systemName: "circle"), for: .normal)
                } else {
                    self.selectedDays.insert(day)
                    button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                }
            }), for: .touchUpInside)

            dayButtons.append(button)

            let container = UIStackView(arrangedSubviews: [button])
            container.axis = .vertical
            container.spacing = 4

            if index < days.count - 1 {
                let divider = UIView()
                divider.backgroundColor = UIColor.systemGray5
                divider.snp.makeConstraints { make in
                    make.height.equalTo(1)
                }
                container.addArrangedSubview(divider)
            }

            dayViews.append(container)
        }

        for button in dayButtons {
            if let title = button.title(for: .normal), selectedDays.contains(title) {
                button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            }
        }

        let stack = UIStackView(arrangedSubviews: [title, desc, subHeader, selectAllButton] + dayViews)
        stack.axis = .vertical
        stack.spacing = 12

        let addButton = UIButton(type: .system)
        addButton.setTitle("Ekle", for: .normal)
        addButton.backgroundColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        addButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        addButton.isEnabled = false
        addButton.alpha = 0.5
        addButton.addTarget(self, action: #selector(didTapAddRoutineToUserDefaults), for: .touchUpInside)
        self.addButton = addButton
        updateAddButtonState()

        let infoLabel = UILabel()
        infoLabel.text = "Bu adım, seçtiğiniz günlerde haftalık olarak tekrarlanacaktır"
        infoLabel.font = UIFont.systemFont(ofSize: 12)
        infoLabel.textColor = .gray
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0

        let bottomStack = UIStackView(arrangedSubviews: [addButton, infoLabel])
        bottomStack.axis = .vertical
        bottomStack.spacing = 8

        let containerStack = UIStackView(arrangedSubviews: [stack, bottomStack])
        containerStack.axis = .vertical
        containerStack.spacing = 24
        detail.addSubview(containerStack)

        containerStack.snp.makeConstraints { make in
            make.top.equalTo(detail.snp.top).offset(24)
            make.leading.equalTo(detail.snp.leading).offset(24)
            make.trailing.equalTo(detail.snp.trailing).offset(-24)
        }

        self.detailView = detail
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .darkGray
        closeButton.addTarget(self, action: #selector(closeDetailView), for: .touchUpInside)
        detail.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(detail.snp.top).offset(16)
            make.trailing.equalTo(detail.snp.trailing).offset(-16)
            make.width.height.equalTo(24)
        }
    }
    
    @objc private func closeDetailView() {
        detailView?.removeFromSuperview()
    }

    @objc private func selectAllDays() {
        let allDays = ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi", "Pazar"]

        if selectedDays == Set(allDays) {
            // Zaten hepsi seçiliyse -> Hepsini kaldır
            selectedDays.removeAll()
        } else {
            // Değilse -> Hepsini seç
            selectedDays = Set(allDays)
        }

        // UI buton ikonlarını güncelle
        for button in dayButtons {
            if let day = button.title(for: .normal), selectedDays.contains(day) {
                button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            } else {
                button.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
    }
    
    @objc private func didTapAddRoutineToUserDefaults() {
        guard let itemName = selectedItemName else { return }

        let routine = SavedRoutine(
            name: itemName,
            type: isMorningRoutine ? "sabah" : "aksam",
            days: Array(selectedDays)
        )

        var saved = loadSavedRoutines()

     
        let alreadyExists = saved.contains { existing in
            existing.name == routine.name &&
            existing.type == routine.type &&
            !Set(existing.days).intersection(selectedDays).isEmpty
        }

        if alreadyExists {
            let saved = loadSavedRoutines()
            
            // Hangi günlerde çakışma var?
            let overlappingDays = saved
                .first(where: { $0.name == routine.name && $0.type == routine.type })?
                .days
                .filter { selectedDays.contains($0) } ?? []

            let daysString = overlappingDays.joined(separator: ", ")
            let message = "Bu rutin zaten şu günlerde var: \(daysString) ✨"

            let alert = UIAlertController(title: "Zaten Eklenmiş", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            self.present(alert, animated: true)
            return
        }
    
        if let index = saved.firstIndex(where: { $0.name == routine.name && $0.type == routine.type }) {
            let combinedDays = Array(Set(saved[index].days + routine.days))
            saved[index] = SavedRoutine(name: routine.name, type: routine.type, days: combinedDays)
        } else {
            saved.append(routine)
        }

        if let encoded = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(encoded, forKey: "dynamicRoutines")
        }

        NotificationCenter.default.post(name: Notification.Name("RoutineAdded"), object: nil)
        dismiss(animated: true)
    }
}

extension RoutineCategoryBottomSheet: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedSection == section ? 2 : 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 56
        } else {
            let category = categories[indexPath.section]
            let itemCount = itemsByCategory[category]?.count ?? 0
            let itemsPerRow = 2
            let rowCount = ceil(Double(itemCount) / Double(itemsPerRow))
            let itemHeight: CGFloat = 50
            let spacing: CGFloat = 8
            let verticalPadding: CGFloat = 8 + 8

            let totalHeight = (CGFloat(rowCount) * itemHeight) + (CGFloat(rowCount - 1) * spacing) + verticalPadding
            return totalHeight
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = categories[indexPath.section]
            cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            cell.textLabel?.textColor = .label
            
            let isExpanded = expandedSection == indexPath.section
            let arrowImage = UIImage(systemName: isExpanded ? "chevron.down" : "chevron.right")
            
            // Var olanları temizle (çift eklenmesin)
            cell.contentView.subviews.forEach { if $0 is UIImageView { $0.removeFromSuperview() } }
            
            let arrow = UIImageView(image: arrowImage)
            arrow.tintColor = .systemGray
            cell.contentView.addSubview(arrow)
            arrow.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(16)
                make.width.height.equalTo(16)
            }
            
            cell.textLabel?.snp.makeConstraints { make in
                make.leading.equalTo(cell.contentView.snp.leading).offset(16)
                make.centerY.equalToSuperview()
                make.trailing.lessThanOrEqualTo(arrow.snp.leading).offset(-8)
            }

            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            let selectedView = UIView()
            selectedView.backgroundColor = .clear
            cell.selectedBackgroundView = selectedView
            let content = cell.contentView
            content.layer.cornerRadius = 12
            content.layer.masksToBounds = true
            content.layer.borderWidth = 1
            content.layer.borderColor = UIColor.systemGray4.cgColor

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as! CollectionTableViewCell
            let category = categories[indexPath.section]
            cell.configure(with: itemsByCategory[category] ?? [])
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.delegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 0 else { return }

        if expandedSection == indexPath.section {
            expandedSection = nil
        } else {
            expandedSection = indexPath.section
        }
        tableView.reloadData()
    }
}

extension RoutineCategoryBottomSheet: CollectionTableViewCellDelegate {
    func didSelectItem(_ item: String) {
        showDetailView(for: item)
    }
}

class CategoryCell: UITableViewCell {
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentView.backgroundColor = .backgroundcolor
    }
}
