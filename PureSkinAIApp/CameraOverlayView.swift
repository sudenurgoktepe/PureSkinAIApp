//
//  CameraOverlayView.swift
//  PureSkinAIApp
//
//  Created by sude on 9.07.2025.
//

import Foundation
import UIKit
import SnapKit

class CameraOverlayView: UIView {

    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Selfie Talimatları
        
        • Fotoğrafı doğal ışıkta çekin
        • Doğal ifade, gülümsemeyin
        • Yüzünüzü kameraya ortalayın
        """
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()

    private let backgroundView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(backgroundView)
        addSubview(instructionsLabel)

        backgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.25)
        }

        instructionsLabel.snp.makeConstraints { make in
            make.edges.equalTo(backgroundView).inset(16)
        }
    }

    func showAndAutoDismiss(after seconds: Double = 2) {
        alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            UIView.animate(withDuration: 0.5) {
                self.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
            }
        }
    }
}
