//
//  AnalysisLoadingViewController.swift
//  PureSkinAIApp
//
//  Created by sude on 9.07.2025.

import UIKit

final class AnalysisLoadingViewController: UIViewController {

    private let image: UIImage
    private let imageView = UIImageView()
    private let ring = CAShapeLayer()
    private let statusLabel = UILabel()
    private let readyButton = UIButton(type: .system)
    private var analysisResultText: String?
    private var dotTimer: Timer?   // ✅ nokta animasyonu için

    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        startAnimating()
        analyzeSkin()
    }

    private func setupUI() {
        let size: CGFloat = 200

        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = size/2
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: size),
            imageView.heightAnchor.constraint(equalToConstant: size)
        ])

        // dönen halka
        let path = UIBezierPath(arcCenter: .zero, radius: size/2 + 10, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        ring.path = path.cgPath
        ring.strokeColor = UIColor.systemGreen.cgColor
        ring.fillColor = UIColor.clear.cgColor
        ring.lineWidth = 4
        ring.lineCap = .round
        ring.position = CGPoint(x: size/2, y: size/2)
        imageView.layer.addSublayer(ring)

        statusLabel.text = "Cildiniz analiz ediliyor"
        statusLabel.font = .systemFont(ofSize: 18, weight: .medium)
        statusLabel.textColor = .label
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        readyButton.setTitle("Hazırım", for: .normal)
        readyButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        readyButton.backgroundColor = .systemGreen
        readyButton.tintColor = .white
        readyButton.layer.cornerRadius = 10
        readyButton.contentEdgeInsets = .init(top: 12, left: 24, bottom: 12, right: 24)
        readyButton.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
        readyButton.isHidden = true
        view.addSubview(readyButton)
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            readyButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 24),
            readyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func startAnimating() {
        let rot = CABasicAnimation(keyPath: "transform.rotation")
        rot.toValue = CGFloat.pi * 2
        rot.duration = 1.5
        rot.repeatCount = .infinity
        ring.add(rot, forKey: "rot")

        // ✅ Nokta animasyonu başlat
        startDotsAnimation()
    }

    private func startDotsAnimation() {
        var dotCount = 0
        dotTimer?.invalidate()
        dotTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            dotCount = (dotCount + 1) % 4 // 0,1,2,3 döner
            let dots = String(repeating: ".", count: dotCount)
            self.statusLabel.text = "Cildiniz analiz ediliyor\(dots)"
        }
    }

    private func stopDotsAnimation() {
        dotTimer?.invalidate()
        dotTimer = nil
    }

    // --- Gemini isteği (kısa ve net) ---
    private func analyzeSkin() {
        guard let resized = resize(image: image, maxDimension: 1024),
              let data = resized.jpegData(compressionQuality: 0.65) else { return }

        let payload: [String: Any] = [
            "contents": [[
                "parts": [
                    ["text": """
                    Bu görseldeki kişinin cilt analizini yap.
                    1) Genel Cilt Skoru (0-100)
                    2) Değerlendirme: uzun paragraf
                    3) En belirgin 6 başlığı seç ve her birine 0-100 arası skor ver.
                                   Aşağıdaki formatta yaz:

                                Göz Altı Morlukları: 75
                                Donukluk: 80
                                İnce Çizgiler: 95
                                ...

                    Her satırda SADECE 1 başlık ve 1 sayı olsun.
                    """],

                    ["inlineData": ["mimeType": "image/jpeg", "data": data.base64EncodedString()]]
                ]
            ]],
            "generationConfig": ["response_mime_type": "text/plain"]
        ]

        var req = URLRequest(url: URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent")!)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("AIzaSyDduJdwtimnfQ9RKB_jaTT_6vXx1pQ56cc", forHTTPHeaderField: "x-goog-api-key")
        req.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: req) { [weak self] data, _, _ in
            guard let self, let data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let candidates = json["candidates"] as? [[String: Any]] else { return }

            var text = ""
            if let contentArr = (candidates.first?["content"] as? [String: Any])?["parts"] as? [[String: Any]] {
                text = contentArr.compactMap { $0["text"] as? String }.joined(separator: "\n")
            } else if let contentArr = (candidates.first?["content"] as? [[String: Any]])?.first?["parts"] as? [[String: Any]] {
                text = contentArr.compactMap { $0["text"] as? String }.joined(separator: "\n")
            }

            DispatchQueue.main.async {
                self.ring.removeAllAnimations()
                self.stopDotsAnimation() // ✅ Nokta animasyonu durdur
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.statusLabel.text = "Analiz sonucu alınamadı."
                    self.readyButton.isHidden = true
                } else {
                    self.analysisResultText = text
                    self.statusLabel.text = "Cilt analiziniz tamamlandı"
                    self.readyButton.isHidden = false
                }
            }
        }.resume()
    }

    @objc private func readyButtonTapped() {
        guard let t = analysisResultText else { return }
        let vc = AnalysisViewController(resultText: t, image: image)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    private func resize(image: UIImage, maxDimension: CGFloat) -> UIImage? {
        let scale = min(maxDimension / max(image.size.width, image.size.height), 1)
        let new = CGSize(width: image.size.width*scale, height: image.size.height*scale)
        UIGraphicsBeginImageContextWithOptions(new, true, 0)
        image.draw(in: CGRect(origin: .zero, size: new))
        let out = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return out
    }
}
