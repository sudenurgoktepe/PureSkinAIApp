//
//  AnalysisLoadingViewController.swift
//  PureSkinAIApp
//
//  Created by sude on 9.07.2025.

import Foundation
import UIKit

class AnalysisLoadingViewController: UIViewController {

    private let image: UIImage
    private let imageView = UIImageView()
    private let progressLayer = CAShapeLayer()
    private let statusLabel = UILabel()
    private let readyButton = UIButton(type: .system)
    private var analysisResultText: String?

    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupImageView()
        setupStatusLabel()
        setupReadyButton()
        startAnimating()
        analyzeSkin()
    }

    private func setupImageView() {
        let size: CGFloat = 200
        imageView.image = image
        imageView.layer.cornerRadius = size / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: size),
            imageView.heightAnchor.constraint(equalToConstant: size)
        ])

        let circularPath = UIBezierPath(arcCenter: .zero, radius: size / 2 + 10, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.systemGreen.cgColor
        progressLayer.lineWidth = 4
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.position = CGPoint(x: size / 2, y: size / 2)
        imageView.layer.addSublayer(progressLayer)
    }

    private func setupStatusLabel() {
        statusLabel.text = "Cildiniz analiz ediliyor..."
        statusLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        statusLabel.textAlignment = .center
        statusLabel.textColor = .label
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupReadyButton() {
        readyButton.setTitle("Hazırım", for: .normal)
        readyButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        readyButton.tintColor = .white
        readyButton.backgroundColor = .systemGreen
        readyButton.layer.cornerRadius = 10
        readyButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
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
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1.5
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        progressLayer.add(rotation, forKey: "rotationAnimation")
    }

    private func analyzeSkin() {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else { return }
        let base64String = imageData.base64EncodedString()

        let payload: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": "Bu görseldeki kişinin cilt analizini detaylı olarak yap: \n\n1. Genel Cilt Skoru (0-100 arası puan) \n2. Cilt yaşı (X yaşında görünmektedir gibi) \n3. Detaylı değerlendirme yap(göz altı morlukları, gözenekler, kırışıklıklar, nem, akne, matlık, cilt tonu, esneklik vb. her şeyden bahset) \n4. Aşağıdaki 14 başlık için 0-100 arası skor ver:\n- Göz Altı Morlukları\n- Donukluk\n- İnce Çizgiler\n- Hiper Pigmentasyon\n- Esneklik Kaybı\n- Gözenekler\n- Şişkinlik\n- Kızarıklık\n- Düzensiz Doku\n- Kuru Cilt\n- Kırışıklıklar\n- Akne\n- Siyah Noktalar\n- Beyaz Noktalar\n\nHer skoru kısa yorumla açıkla. Dil: Türkçe, samimi, kullanıcı dostu."],
                        ["inlineData": ["mimeType": "image/jpeg", "data": base64String]]
                    ]
                ]
            ]
        ]

        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyDqxhJAvX0TWiJ1DBnrFoyo8xBsd5rsI8s") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            print("JSON oluşturulamadı: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }

            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let candidates = json["candidates"] as? [[String: Any]],
                   let content = candidates.first?["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let text = parts.first?["text"] as? String {
                    DispatchQueue.main.async {
                        self.analysisResultText = text
                        self.analysisCompletedUI()
                    }
                }
            } catch {
                print("JSON parse hatası: \(error.localizedDescription)")
            }
        }.resume()
    }

    private func analysisCompletedUI() {
        self.progressLayer.removeAllAnimations()
        self.statusLabel.text = "Cilt analiziniz tamamlandı"
        self.readyButton.isHidden = false
    }

    @objc private func readyButtonTapped() {
        guard let analysisResultText = analysisResultText else { return }
        let analysisVC = AnalysisViewController(resultText: analysisResultText, image: image)
        analysisVC.modalPresentationStyle = .fullScreen
        self.present(analysisVC, animated: true)
    }
}
