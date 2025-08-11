import UIKit
import SnapKit

struct RoutineStep {
    let title: String
    let subtitle: String
    let iconName: String
    var isCompleted: Bool = false
}

struct CompletedRoutine: Codable {
    let title: String
    let date: String
    let type: String
}

class RoutinesViewController: UIViewController {
    
    private var selectedDate: Date = Date()
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
        return label
    }()
    private let streakLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .systemRed
        label.text = ""
        return label
    }()
    private let calendarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()

    private let routineSwitch: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Sabah", "Akşam"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(didChangeRoutineType(_:)), for: .valueChanged)
        return control
    }()

    private let completedCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
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
        return stack
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .backgroundcolor
        return table
    }()
   
    private let goToTodayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Bugüne Git", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapGoToToday), for: .touchUpInside)
        return button
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Henüz rutin eklemediniz.\nEklemek için + butonuna tıklayın."
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private var isMorningRoutine: Bool = true
    private var morningRoutine: [RoutineStep] = []
    private var eveningRoutine: [RoutineStep] = []

    private var currentRoutine: [RoutineStep] {
        return isMorningRoutine ? morningRoutine : eveningRoutine
    }

    private func updateCompletedCountLabel() {
        let completedCount = currentRoutine.filter { $0.isCompleted }.count
        completedCountLabel.text = "\(completedCount)/\(currentRoutine.count) Tamamlandı"
    }
    
    private func updateEmptyStateLabel() {
        emptyStateLabel.isHidden = !currentRoutine.isEmpty
    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }

    func markCompletedStepsForSelectedDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDay = formatter.string(from: selectedDate)
        let saved = UserDefaults.standard.loadCompletedRoutines()
        let filtered = saved.filter { $0.date == selectedDay }

        for i in 0..<morningRoutine.count {
            let step = morningRoutine[i]
            let isDone = filtered.contains {
                $0.title == step.title && $0.type == "sabah"
            }
            morningRoutine[i].isCompleted = isDone
        }

        for i in 0..<eveningRoutine.count {
            let step = eveningRoutine[i]
            let isDone = filtered.contains {
                $0.title == step.title && $0.type == "aksam"
            }
            eveningRoutine[i].isCompleted = isDone
        }
    }
    
    private func updateStreakLabel() {
           let count = calculateStreakCount()
           streakLabel.text = count > 0 ? "🔥 \(count)" : ""
       }
    
    private func updateTodayLabel() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")

        if isSameDay(selectedDate, Date()) {
            todayLabel.text = "Bugün"
            goToTodayButton.isHidden = true
        } else {
            formatter.dateFormat = "EEEE, d"
            todayLabel.text = formatter.string(from: selectedDate).capitalized
            goToTodayButton.isHidden = false
        }
    }

    @objc private func didChangeRoutineType(_ sender: UISegmentedControl) {
        isMorningRoutine = sender.selectedSegmentIndex == 0
        (routineHeaderStack.arrangedSubviews[0] as? UILabel)?.text = isMorningRoutine ? "Sabah Rutini" : "Akşam Rutini"
        updateCompletedCountLabel()
        markCompletedStepsForSelectedDate()
        updateTodayLabel()
        updateEmptyStateLabel()
        tableView.reloadData()
    }

    @objc private func didTapAddRoutine() {
        let bottomSheet = RoutineCategoryBottomSheet()
        bottomSheet.isMorningRoutine = self.isMorningRoutine
        bottomSheet.selectedDate = self.selectedDate
        bottomSheet.modalPresentationStyle = .pageSheet
     
        if let sheet = bottomSheet.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom(identifier: .init("expanded")) { context in
                        return context.maximumDetentValue * 0.85
                    }
                ]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            } else {
                sheet.detents = [.medium()]
            }
        }
        present(bottomSheet, animated: true, completion: nil)
    }

    @objc private func didTapGoToToday() {
        selectedDate = Date()
        
        appendDynamicMorningStepsIfNeeded()
        appendDynamicEveningStepsIfNeeded()   

        markCompletedStepsForSelectedDate()
        updateTodayLabel()
        calendarStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        setupCalendar()
        tableView.reloadData()
        updateEmptyStateLabel()
        updateCompletedCountLabel()
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
        containerView.isUserInteractionEnabled = true
        containerView.tag = Int(date.timeIntervalSince1970)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDay(_:)))
        containerView.addGestureRecognizer(tap)

        let dayLabel = UILabel()
        dayLabel.text = dateFormatter.string(from: date)
        dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        dayLabel.textColor = .systemGray
        dayLabel.textAlignment = .center

        let dateLabel = UILabel()
        dateLabel.text = "\(Calendar.current.component(.day, from: date))"
        dateLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        dateLabel.textAlignment = .center

        containerView.addSubview(dayLabel)
        containerView.addSubview(dateLabel)

        if isSameDay(date, selectedDate) {
            containerView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            containerView.layer.cornerRadius = 12
        }

        if isSameDay(date, Date()) {
            let underline = UIView()
            underline.backgroundColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
            containerView.addSubview(underline)

            underline.snp.makeConstraints { make in
                make.centerX.equalTo(dateLabel)
                make.width.equalTo(dateLabel).multipliedBy(0.8)
                make.bottom.equalTo(dateLabel).offset(2)
                make.height.equalTo(3)
            }
        }

        containerView.addSubview(dayLabel)
        containerView.addSubview(dateLabel)

        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview()
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
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
        view.addSubview(streakLabel)
        view.addSubview(goToTodayButton)
        todayLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(20)
        }
       
        calendarStackView.snp.makeConstraints { make in
            make.top.equalTo(todayLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(70)
        }

        routineSwitch.snp.makeConstraints { make in
            make.top.equalTo(calendarStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        routineHeaderStack.snp.makeConstraints { make in
            make.top.equalTo(routineSwitch.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        completedCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(routineHeaderStack.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(routineHeaderStack.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        streakLabel.snp.makeConstraints { make in
            make.centerY.equalTo(todayLabel)
            make.leading.equalTo(todayLabel.snp.trailing).offset(8)
        }

        goToTodayButton.snp.makeConstraints { make in
            make.centerY.equalTo(todayLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(emptyStateLabel)
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        setupCalendar()
    }
    
    private func appendDynamicMorningStepsIfNeeded() {
        morningRoutine = []
        let routines = loadSavedRoutines()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "EEEE"
        let currentDay = formatter.string(from: selectedDate)

        for routine in routines {
            if routine.type == "sabah", routine.days.contains(currentDay) {
                let step = RoutineStep(
                    title: routine.name,
                    subtitle: "Bu rutin için ürün seçildi",
                    iconName: "sunny"
                )
                morningRoutine.append(step)
            }
        }
    }
    private func calculateStreakCount() -> Int {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let allCompleted = UserDefaults.standard.loadCompletedRoutines()
        let allSaved = UserDefaults.standard.loadSavedRoutines()
        
        var streak = 0
        var dayOffset = 0

        while true {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { break }
            let dateStr = formatter.string(from: date)

            let savedRoutinesForThatDay = allSaved.filter {
                let dayFormatter = DateFormatter()
                dayFormatter.locale = Locale(identifier: "tr_TR")
                dayFormatter.dateFormat = "EEEE"
                let dayName = dayFormatter.string(from: date)
                return $0.days.map { $0.lowercased() }.contains(dayName.lowercased())
            }

            let expected = Set(savedRoutinesForThatDay.map { $0.name + $0.type })
            let completed = allCompleted.filter { $0.date == dateStr }
            let completedSet = Set(completed.map { $0.title + $0.type })

            print("=== \(dateStr) ===")
            print("Expected:", expected)
            print("Completed:", completedSet)

            if !expected.isEmpty && expected.isSubset(of: completedSet) {
                streak += 1
            } else if !expected.isEmpty {
                break
            }

            dayOffset += 1
        }

        return streak
    }

    private func appendDynamicEveningStepsIfNeeded() {
        eveningRoutine = []
        let routines = loadSavedRoutines()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "EEEE"
        let currentDay = formatter.string(from: selectedDate)

        for routine in routines {
            if routine.type == "aksam", routine.days.contains(currentDay) {
                let step = RoutineStep(
                    title: routine.name,
                    subtitle: "Bu rutin için ürün seçildi",
                    iconName: "moon"
                )
                eveningRoutine.append(step)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.navigationBar.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RoutineTableViewCell.self, forCellReuseIdentifier: RoutineTableViewCell.identifier)
        UserDefaults.standard.cleanDuplicateRoutines()
        appendDynamicMorningStepsIfNeeded()
        appendDynamicEveningStepsIfNeeded()
        markCompletedStepsForSelectedDate()
        updateCompletedCountLabel()
        NotificationCenter.default.addObserver(self, selector: #selector(handleRoutineAdded), name: Notification.Name("RoutineAdded"), object: nil)
        updateTodayLabel()
        updateEmptyStateLabel()
        updateStreakLabel()
    }

    @objc private func didTapDay(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        selectedDate = Date(timeIntervalSince1970: TimeInterval(tag))
        appendDynamicMorningStepsIfNeeded()
        appendDynamicEveningStepsIfNeeded()
        markCompletedStepsForSelectedDate()
        updateCompletedCountLabel()
        tableView.reloadData()
        calendarStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        setupCalendar()
        updateTodayLabel()
        updateEmptyStateLabel()
    }

    @objc private func handleRoutineAdded() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.appendDynamicMorningStepsIfNeeded()
            self.appendDynamicEveningStepsIfNeeded()
            self.markCompletedStepsForSelectedDate()

            DispatchQueue.main.async {
                self.updateCompletedCountLabel()
                self.tableView.reloadData()
                self.updateEmptyStateLabel()
                self.updateStreakLabel()
            }
        }
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDayString = formatter.string(from: selectedDate)

        let title = currentRoutine[indexPath.row].title
        let type = isMorningRoutine ? "sabah" : "aksam"
        let routineKey = CompletedRoutine(title: title, date: selectedDayString, type: type)

        var isNowCompleted = false

        if isMorningRoutine {
            morningRoutine[indexPath.row].isCompleted.toggle()
            isNowCompleted = morningRoutine[indexPath.row].isCompleted
        } else {
            eveningRoutine[indexPath.row].isCompleted.toggle()
            isNowCompleted = eveningRoutine[indexPath.row].isCompleted
        }

        if isNowCompleted {
            UserDefaults.standard.saveCompletedRoutine(routineKey)
        } else {
            UserDefaults.standard.removeCompletedRoutine(routineKey)
        }

        tableView.reloadRows(at: [indexPath], with: .automatic)
        updateCompletedCountLabel()
        updateStreakLabel()
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let stepToRemove = currentRoutine[indexPath.row]
            let dayFormatter = DateFormatter()
            dayFormatter.locale = Locale(identifier: "tr_TR")
            dayFormatter.dateFormat = "EEEE"
            let selectedDay = dayFormatter.string(from: selectedDate)
            var saved = UserDefaults.standard.loadSavedRoutines()
            let title = stepToRemove.title
            let type = isMorningRoutine ? "sabah" : "aksam"
            let dayFormatter2 = DateFormatter()
            dayFormatter2.dateFormat = "yyyy-MM-dd"
            let selectedDayString = dayFormatter2.string(from: selectedDate)
            let completed = CompletedRoutine(title: title, date: selectedDayString, type: type)
            UserDefaults.standard.removeCompletedRoutine(completed)

            if let index = saved.firstIndex(where: { $0.name == stepToRemove.title && $0.type == (isMorningRoutine ? "sabah" : "aksam") }) {
                var routine = saved[index]
                routine.days.removeAll { $0 == selectedDay }

                if routine.days.isEmpty {
                    saved.remove(at: index)
                } else {
                    saved[index] = routine
                }

                DispatchQueue.global(qos: .background).async {
                    if let data = try? JSONEncoder().encode(saved) {
                        UserDefaults.standard.set(data, forKey: "dynamicRoutines")
                    }
                }
            }

            if isMorningRoutine {
                morningRoutine.remove(at: indexPath.row)
            } else {
                eveningRoutine.remove(at: indexPath.row)
            }

            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateCompletedCountLabel()
            updateEmptyStateLabel()
            updateStreakLabel()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            self.tableView(tableView, commit: .delete, forRowAt: indexPath)
            completionHandler(true)
        }

        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = UIColor(red: 220/255, green: 53/255, blue: 69/255, alpha: 1.0)

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

extension UserDefaults {
    private var key: String { return "completedRoutines" }

    func saveCompletedRoutine(_ routine: CompletedRoutine) {
        var saved = loadCompletedRoutines()
        saved.append(routine)
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? JSONEncoder().encode(saved) {
                UserDefaults.standard.set(data, forKey: self.key)
            }
        }
    }

    func loadCompletedRoutines() -> [CompletedRoutine] {
        guard let data = data(forKey: key),
              let decoded = try? JSONDecoder().decode([CompletedRoutine].self, from: data) else {
            return []
        }
        return decoded
    }
    
    func cleanDuplicateRoutines() {
        var saved = loadSavedRoutines()
        var unique: [SavedRoutine] = []

        for routine in saved {
            if let index = unique.firstIndex(where: { $0.name == routine.name && $0.type == routine.type }) {
                let combinedDays = Array(Set(unique[index].days + routine.days))
                unique[index] = SavedRoutine(name: routine.name, type: routine.type, days: combinedDays)
            } else {
                unique.append(routine)
            }
        }

        if let encoded = try? JSONEncoder().encode(unique) {
            set(encoded, forKey: "dynamicRoutines")
        }
    }
    
    func removeCompletedRoutine(_ routine: CompletedRoutine) {
        var saved = loadCompletedRoutines()
        saved.removeAll {
            $0.title == routine.title &&
            $0.date == routine.date &&
            $0.type == routine.type
        }

        DispatchQueue.global(qos: .background).async {
            if let data = try? JSONEncoder().encode(saved) {
                UserDefaults.standard.set(data, forKey: self.key)
            }
        }
    }

    func saveDynamicRoutine(_ routine: SavedRoutine) {
        var saved = loadSavedRoutines()

        if let index = saved.firstIndex(where: { $0.name == routine.name && $0.type == routine.type }) {
            let existing = saved[index]
            let combinedDays = Array(Set(existing.days + routine.days))
            saved[index] = SavedRoutine(name: routine.name, type: routine.type, days: combinedDays)
        } else {
            saved.append(routine)
        }

        if let data = try? JSONEncoder().encode(saved) {
            set(data, forKey: "dynamicRoutines")
        }
    }
        func loadSavedRoutines() -> [SavedRoutine] {
            guard let data = data(forKey: "dynamicRoutines"),
                  let decoded = try? JSONDecoder().decode([SavedRoutine].self, from: data) else {
                return []
            }
            return decoded
        }
 }

func todayString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: Date())
}

extension RoutinesViewController {
    func loadSavedRoutines() -> [SavedRoutine] {
        guard let data = UserDefaults.standard.data(forKey: "dynamicRoutines"),
              let decoded = try? JSONDecoder().decode([SavedRoutine].self, from: data) else {
            return []
        }
        return decoded
    }
}
