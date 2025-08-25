//
//  AnalysisViewController.swift
//  PureSkinAIApp
//
//  Created by sude on 9.07.2025.
//

import UIKit
import SnapKit

// MARK: - Basit veri çıkarımı (kısa parser)
private let metricNames = [
    "Göz Altı Morlukları","Donukluk","İnce Çizgiler","Hiper Pigmentasyon","Esneklik Kaybı",
    "Gözenekler","Şişkinlik","Kızarıklık","Düzensiz Doku","Kuru Cilt",
    "Kırışıklıklar","Akne","Siyah Noktalar","Beyaz Noktalar"
]

private func firstNumber(_ s: String) -> Int? {
    if let r = s.range(of: #"(?<!\d)\d{1,3}(?!\d)"#, options: .regularExpression) {
        return max(0, min(100, Int(s[r])!))
    }
    return nil
}

private func numberNear(keyword: String, in text: String, window: Int = 120) -> Int? {
    guard let r = text.range(of: keyword, options: .caseInsensitive) else { return nil }
    let tail = String(text[r.upperBound...]).prefix(window)
    if let m = tail.range(of: #"\b(100|\d{1,2})\b(?!\))"#, options: .regularExpression),
       let n = Int(tail[m]) {
        return max(0, min(100, n))
    }
    return nil
}

private func extractEvaluationParagraph(from text: String) -> String? {
    if let startRange = text.range(of: "2)"),
       let endRange = text.range(of: "3)") {
        var section = String(text[startRange.upperBound..<endRange.lowerBound])
        section = section
            .replacingOccurrences(of: "Değerlendirme:", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "Değerlendirme", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "**", with: "")
            .replacingOccurrences(of: "---", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return section.isEmpty ? nil : section
    }
    if let startRange = text.range(of: "2)") {
        var section = String(text[startRange.upperBound...])
        section = section
            .replacingOccurrences(of: "Değerlendirme:", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "Değerlendirme", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "**", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return section.isEmpty ? nil : section
    }
    return nil
}

final class AnalysisViewController: UIViewController {

    private let resultText: String
    private let image: UIImage

    // UI
    private let scroll = UIScrollView()
    private let content = UIView()
    private let closeBtn = UIButton(type: .system)
    private let avatar = UIImageView()

    private let scoreCard = UIView()
    private let scoreTitle = UILabel()
    private let scoreLabel = UILabel()
    private let dateLabel = UILabel()

    private let evalCard = UIView()
    private let evalTitle = UILabel()
    private let evalBody = UILabel()

    private let metricsCard = UIView()
    private let metricsTitle = UILabel()
    private let metricsStack = UIStackView()

    private let noteCard = UIView()
    private let noteTitle = UILabel()
    private let noteBody = UILabel()

    private let disclaimer = UILabel()

    // Data
    private var score: Int?
    private var summary: String?
    private var metrics: [(String, Int)] = []

    init(resultText: String, image: UIImage) {
        self.resultText = resultText
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        parse(resultText)
        buildUI()
        bind()
    }

    private func parse(_ text: String) {
        let clean = text.replacingOccurrences(of: "\r", with: "")
        let lines = clean.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespaces) }

        if let s = numberNear(keyword: "Genel Cilt Skoru", in: clean)
            ?? numberNear(keyword: "Skor", in: clean) {
            score = s
        } else if let l = lines.first(where: { $0.localizedCaseInsensitiveContains("skor") }),
                  let n = firstNumber(l) {
            score = n
        }

        summary = extractEvaluationParagraph(from: clean)

        metrics.removeAll()
        
        for line in lines {
               for name in metricNames {
                   if line.localizedCaseInsensitiveContains(name),
                      let n = firstNumber(line) {
                       metrics.append((name, n))
                   }
               }
           }
    }

    // MARK: UI
    private func cardStyle(_ v: UIView) {
        v.backgroundColor = .secondarySystemBackground
        v.layer.cornerRadius = 20
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowRadius = 12
        v.layer.shadowOffset = CGSize(width: 0, height: 6)
    }

    private func buildUI() {
        view.addSubview(scroll)
        scroll.addSubview(content)
        scroll.alwaysBounceVertical = true
        scroll.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        content.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scroll.snp.width)
        }

        closeBtn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeBtn.tintColor = .secondaryLabel
        closeBtn.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.size.equalTo(28)
        }

        content.addSubview(avatar)
        avatar.image = image
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 72
        avatar.layer.masksToBounds = true
        avatar.layer.borderWidth = 4
        avatar.layer.borderColor = UIColor.systemBackground.cgColor
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(144)
        }

        [scoreCard, evalCard, metricsCard, noteCard].forEach(cardStyle)
        content.addSubview(scoreCard)
        scoreCard.snp.makeConstraints {
            $0.top.equalTo(avatar.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        scoreTitle.text = "Genel Cilt Skoru"
        scoreTitle.font = .preferredFont(forTextStyle: .headline)
        scoreTitle.adjustsFontForContentSizeCategory = true
        scoreLabel.font = .preferredFont(forTextStyle: .title1)
        scoreLabel.adjustsFontForContentSizeCategory = true
        scoreLabel.textColor = UIColor(red: 0.93, green: 0.67, blue: 0.55, alpha: 1.0)
        dateLabel.font = .preferredFont(forTextStyle: .caption2)
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.textColor = .tertiaryLabel

        [scoreTitle, scoreLabel, dateLabel].forEach(scoreCard.addSubview)
        scoreTitle.snp.makeConstraints { $0.top.equalToSuperview().inset(18); $0.leading.trailing.equalToSuperview().inset(16) }
        scoreLabel.snp.makeConstraints { $0.top.equalTo(scoreTitle.snp.bottom).offset(6); $0.leading.trailing.equalToSuperview().inset(16) }
        dateLabel.snp.makeConstraints { $0.top.equalTo(scoreLabel.snp.bottom).offset(8); $0.leading.trailing.equalToSuperview().inset(16); $0.bottom.equalToSuperview().inset(14) }

        content.addSubview(evalCard)
        evalCard.snp.makeConstraints {
            $0.top.equalTo(scoreCard.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        evalTitle.text = "Değerlendirme"
        evalTitle.font = .preferredFont(forTextStyle: .title3)
        evalTitle.adjustsFontForContentSizeCategory = true
        evalBody.font = .preferredFont(forTextStyle: .callout)
        evalBody.adjustsFontForContentSizeCategory = true
        evalBody.numberOfLines = 0
        [evalTitle, evalBody].forEach(evalCard.addSubview)
        evalTitle.snp.makeConstraints { $0.top.equalToSuperview().inset(18); $0.leading.trailing.equalToSuperview().inset(16) }
        evalBody.snp.makeConstraints { $0.top.equalTo(evalTitle.snp.bottom).offset(8); $0.leading.trailing.equalToSuperview().inset(16); $0.bottom.equalToSuperview().inset(16) }

        content.addSubview(metricsCard)
        metricsCard.snp.makeConstraints {
            $0.top.equalTo(evalCard.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        metricsTitle.text = "Detaylı Analiz"
        metricsTitle.font = .preferredFont(forTextStyle: .title3)
        metricsTitle.adjustsFontForContentSizeCategory = true
        metricsStack.axis = .vertical
        metricsStack.spacing = 12
        [metricsTitle, metricsStack].forEach(metricsCard.addSubview)
        metricsTitle.snp.makeConstraints { $0.top.equalToSuperview().inset(18); $0.leading.trailing.equalToSuperview().inset(16) }
        metricsStack.snp.makeConstraints { $0.top.equalTo(metricsTitle.snp.bottom).offset(12); $0.leading.trailing.equalToSuperview().inset(16); $0.bottom.equalToSuperview().inset(16) }

        content.addSubview(noteCard)
        noteCard.snp.makeConstraints {
            $0.top.equalTo(metricsCard.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        noteTitle.text = "Önemli Not"
        noteTitle.font = .preferredFont(forTextStyle: .title3)
        noteTitle.adjustsFontForContentSizeCategory = true
        noteBody.font = .preferredFont(forTextStyle: .callout)
        noteBody.adjustsFontForContentSizeCategory = true
        noteBody.numberOfLines = 0
        [noteTitle, noteBody].forEach(noteCard.addSubview)
        noteTitle.snp.makeConstraints { $0.top.equalToSuperview().inset(18); $0.leading.trailing.equalToSuperview().inset(16) }
        noteBody.snp.makeConstraints { $0.top.equalTo(noteTitle.snp.bottom).offset(8); $0.leading.trailing.equalToSuperview().inset(16); $0.bottom.equalToSuperview().inset(16) }

        content.addSubview(disclaimer)
        disclaimer.text = "PureSkinAI hatalar yapabilir."
        disclaimer.textAlignment = .center
        disclaimer.textColor = .tertiaryLabel
        disclaimer.font = .preferredFont(forTextStyle: .footnote)
        disclaimer.adjustsFontForContentSizeCategory = true
        disclaimer.snp.makeConstraints {
            $0.top.equalTo(noteCard.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    // MARK: Bind
    private func bind() {
        scoreLabel.text = score.map(String.init) ?? "—"

        let df = DateFormatter(); df.dateFormat = "dd.MM.yyyy - HH:mm"
        dateLabel.text = df.string(from: Date())

        evalBody.text = summary ?? "Değerlendirme metni bulunamadı."

        metricsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (name, val) in metrics {
            let row = makeMetricRow(name: name, value: val)
            row.snp.makeConstraints { $0.height.equalTo(28) }
            metricsStack.addArrangedSubview(row)
        }

        noteBody.text = """
        Aydınlatma koşulları ve makyaj, PureSkin AI'nın değerlendirme sonuçlarını etkileyebilir.
        • En doğru sonuçlar için, doğal ışıkta ve makyajsız fotoğraf çekin.
        • Sonuçlarınıza her zaman profil sayfanızdan ulaşabilirsiniz.
        """
    }

    private func makeMetricRow(name: String, value: Int) -> UIView {
        let row = UIView()
        let nameLbl = UILabel()
        nameLbl.text = name
        nameLbl.font = .preferredFont(forTextStyle: .subheadline)
        nameLbl.adjustsFontForContentSizeCategory = true

        let valueLbl = UILabel()
        valueLbl.text = "\(value)"
        valueLbl.font = .preferredFont(forTextStyle: .footnote)
        valueLbl.adjustsFontForContentSizeCategory = true
        valueLbl.textColor = .secondaryLabel

        let barBG = UIView(); barBG.backgroundColor = .systemGray5; barBG.layer.cornerRadius = 6; barBG.clipsToBounds = true
        let barFill = UIView()
        barFill.backgroundColor = .systemGreen

        barFill.layer.cornerRadius = 6; barFill.clipsToBounds = true

        [nameLbl, barBG, valueLbl].forEach(row.addSubview)
        barBG.addSubview(barFill)

        nameLbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueLbl.setContentHuggingPriority(.required, for: .horizontal)

        nameLbl.snp.makeConstraints { $0.leading.centerY.equalToSuperview() }
        valueLbl.snp.makeConstraints { $0.trailing.centerY.equalToSuperview() }
        barBG.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(nameLbl.snp.trailing).offset(8)
            $0.leading.equalToSuperview().offset(180).priority(250)
            $0.trailing.equalTo(valueLbl.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(10)
        }
        row.layoutIfNeeded()
        barFill.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(CGFloat(value)/100.0)
        }
        return row
    }

    @objc private func dismissSelf() {
        if let score = score {
            let analysis = SkinAnalysis(
                score: score,
                image: image,
                resultText: resultText // tüm texti kaydediyoruz
            )
            
            // Eğer aynı text zaten varsa tekrar eklemesin
            let existing = SkinAnalysisStore.load()
            if !existing.contains(where: { $0.resultText == resultText }) {
                SkinAnalysisStore.save(analysis)
            }
        }
        view.window?.rootViewController?.dismiss(animated: true)
    }
}
