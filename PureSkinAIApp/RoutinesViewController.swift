import UIKit

struct RoutineStep {
    let title: String
    let subtitle: String
    let iconName: String
    var isCompleted: Bool = false
}

class RoutinesViewController: UIViewController {

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "EEE"
        return formatter
    }()

    private let todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Bugün"
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let calendarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let routineSwitch: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Sabah", "Akşam"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(didChangeRoutineType(_:)), for: .valueChanged)
        return control
    }()

    private let completedCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "0/6 Tamamlandı"
        return label
    }()

    private let routineHeaderStack: UIStackView = {
        let label = UILabel()
        label.text = "Sabah Rutini"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .labelPrimary

        let plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        plusButton.tintColor = .systemGreen
        plusButton.addTarget(nil, action: #selector(didTapAddRoutine), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [label, plusButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .clear
        return table
    }()

    private var isMorningRoutine: Bool = true

    private var morningRoutine: [RoutineStep] = [
        RoutineStep(title: "Su Bazlı Temizleme", subtitle: "Bu rutin için ürün seçilmedi", iconName: "sunny"),
        RoutineStep(title: "Tonik Kullanımı", subtitle: "Bu rutin için ürün seçilmedi", iconName: "sunny"),
        RoutineStep(title: "Peptit Serumu Uygulaması", subtitle: "Bu rutin için ürün seçilmedi", iconName: "sunny"),
        RoutineStep(title: "Alpha Arbutin Uygulaması", subtitle: "Bu rutin için ürün seçilmedi", iconName: "sunny"),
        RoutineStep(title: "Su Bazlı Nemlendirme", subtitle: "Bu rutin için ürün seçilmedi", iconName: "sunny"),
        RoutineStep(title: "Göz Kremi Uygulaması", subtitle: "Bu rutin için ürün seçilmedi", iconName: "sunny")
    ]

    private var eveningRoutine: [RoutineStep] = [
        RoutineStep(title: "Yağ Bazlı Temizleyici", subtitle: "Bu rutin için ürün seçilmedi", iconName: "moon"),
        RoutineStep(title: "Yüz Yıkama Jeli", subtitle: "Bu rutin için ürün seçilmedi", iconName: "moon"),
        RoutineStep(title: "Peeling veya Maske", subtitle: "Bu rutin için ürün seçilmedi", iconName: "moon"),
        RoutineStep(title: "Nem Serumu", subtitle: "Bu rutin için ürün seçilmedi", iconName: "moon"),
        RoutineStep(title: "Gece Nemlendiricisi", subtitle: "Bu rutin için ürün seçilmedi", iconName: "moon"),
        RoutineStep(title: "Gece Göz Serumu", subtitle: "Bu rutin için ürün seçilmedi", iconName: "moon")
    ]

    private var currentRoutine: [RoutineStep] {
        return isMorningRoutine ? morningRoutine : eveningRoutine
    }

    private func updateCompletedCountLabel() {
        let completedCount = currentRoutine.filter { $0.isCompleted }.count
        completedCountLabel.text = "\(completedCount)/\(currentRoutine.count) Tamamlandı"
    }

    @objc private func didChangeRoutineType(_ sender: UISegmentedControl) {
        isMorningRoutine = sender.selectedSegmentIndex == 0
        (routineHeaderStack.arrangedSubviews[0] as? UILabel)?.text = isMorningRoutine ? "Sabah Rutini" : "Akşam Rutini"
        updateCompletedCountLabel()
        tableView.reloadData()
    }

    @objc private func didTapAddRoutine() {
        let bottomSheet = RoutineCategoryBottomSheet()
        bottomSheet.modalPresentationStyle = .pageSheet

        if let sheet = bottomSheet.sheetPresentationController {
            sheet.detents = [.medium()] // veya [.large()]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 20
        }

        bottomSheet.onCategorySelected = { category in
            print("Seçilen kategori: \(category)")
            // buraya yönlendirme yapılabilir
        }

        present(bottomSheet, animated: true, completion: nil)
    }


    private func setupCalendar() {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysToMonday = (weekday + 5) % 7

        for dayOffset in 0...6 {
            let date = calendar.date(byAdding: .day, value: dayOffset - daysToMonday, to: today)!
            let dayView = createDayView(date: date, isToday: dayOffset == daysToMonday)
            calendarStackView.addArrangedSubview(dayView)
        }
    }

    private func createDayView(date: Date, isToday: Bool) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let dayLabel = UILabel()
        dayLabel.text = dateFormatter.string(from: date)
        dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        dayLabel.textColor = .systemGray
        dayLabel.textAlignment = .center
        dayLabel.translatesAutoresizingMaskIntoConstraints = false

        let dateLabel = UILabel()
        dateLabel.text = "\(Calendar.current.component(.day, from: date))"
        dateLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(dayLabel)
        containerView.addSubview(dateLabel)

        if isToday {
            containerView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            containerView.layer.cornerRadius = 12

            let underline = UIView()
            underline.backgroundColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
            underline.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(underline)

            NSLayoutConstraint.activate([
                underline.centerXAnchor.constraint(equalTo: dateLabel.centerXAnchor),
                underline.widthAnchor.constraint(equalTo: dateLabel.widthAnchor, multiplier: 0.8),
                underline.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
                underline.heightAnchor.constraint(equalToConstant: 3)
            ])
        }

        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            dayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])

        return containerView
    }

    private func setupUI() {
        view.backgroundColor = .backgroundcolor

        view.addSubview(todayLabel)
        view.addSubview(calendarStackView)
        view.addSubview(routineSwitch)
        view.addSubview(routineHeaderStack)
        view.addSubview(completedCountLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            todayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            todayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            calendarStackView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 20),
            calendarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendarStackView.heightAnchor.constraint(equalToConstant: 80),

            routineSwitch.topAnchor.constraint(equalTo: calendarStackView.bottomAnchor, constant: 20),
            routineSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            routineSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            routineHeaderStack.topAnchor.constraint(equalTo: routineSwitch.bottomAnchor, constant: 20),
            routineHeaderStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            completedCountLabel.centerYAnchor.constraint(equalTo: routineHeaderStack.centerYAnchor),
            completedCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: routineHeaderStack.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        setupCalendar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.navigationBar.isHidden = true
        updateCompletedCountLabel()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RoutineTableViewCell.self, forCellReuseIdentifier: RoutineTableViewCell.identifier)
    }
}

extension RoutinesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentRoutine.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTableViewCell.identifier, for: indexPath) as? RoutineTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: currentRoutine[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMorningRoutine {
            morningRoutine[indexPath.row].isCompleted.toggle()
        } else {
            eveningRoutine[indexPath.row].isCompleted.toggle()
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        updateCompletedCountLabel()
    }
}
