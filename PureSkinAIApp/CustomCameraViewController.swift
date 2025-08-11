//
//  CustomCameraViewController.swift
//  PureSkinAIApp
//
//  Created by sude on 9.07.2025.
//

import Foundation
import UIKit
import AVFoundation
import SnapKit

class CustomCameraViewController: UIViewController {

    private let captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var capturePhotoOutput: AVCapturePhotoOutput!
    private var capturedImage: UIImage?

    private let shutterButton = UIButton(type: .system)
    private let retakeButton = UIButton(type: .system)
    private let continueButton = UIButton(type: .system)
    private let capturedImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        checkCameraPermission()
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async { self.setupCamera() }
                } else {
                    self.dismiss(animated: true)
                }
            }
        default:
            dismiss(animated: true)
        }
    }

    private func setupCamera() {
        captureSession.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            dismiss(animated: true)
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: camera)
            captureSession.addInput(input)
        } catch {
            print("Camera input error: \(error)")
            dismiss(animated: true)
            return
        }

        capturePhotoOutput = AVCapturePhotoOutput()
        captureSession.addOutput(capturePhotoOutput)

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = view.bounds

        
        DispatchQueue.main.async {
            self.view.layer.addSublayer(self.videoPreviewLayer)
            self.setupUI()
            self.showInstructions()
        }

        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }


    private func setupUI() {
        shutterButton.backgroundColor = .white
        shutterButton.layer.cornerRadius = 45
        shutterButton.layer.borderWidth = 2
        shutterButton.layer.borderColor = UIColor.lightGray.cgColor
        shutterButton.tintColor = .white
        shutterButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        view.addSubview(shutterButton)
        shutterButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(90)
        }

        capturedImageView.contentMode = .scaleAspectFill
        capturedImageView.clipsToBounds = true
        capturedImageView.isHidden = true
        view.addSubview(capturedImageView)
        capturedImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        retakeButton.setTitle("Tekrar Çek", for: .normal)
        retakeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        retakeButton.backgroundColor = UIColor.systemGray.withAlphaComponent(0.7)
        retakeButton.tintColor = .white
        retakeButton.layer.cornerRadius = 10
        retakeButton.addTarget(self, action: #selector(retakePhoto), for: .touchUpInside)
        retakeButton.isHidden = true
        view.addSubview(retakeButton)
        retakeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.trailing.equalTo(view.snp.centerX).offset(-10) // ✅ SOLA ALINDI
            make.width.equalTo(140)
            make.height.equalTo(50)
        }

        continueButton.setTitle("Devam Et", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        continueButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.8)
        continueButton.tintColor = .white
        continueButton.layer.cornerRadius = 10
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        continueButton.isHidden = true
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.leading.equalTo(view.snp.centerX).offset(10) // ✅ SAĞA ALINDI
            make.width.equalTo(140)
            make.height.equalTo(50)
        }

        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(36)
        }

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        view.addGestureRecognizer(pinchGesture)
    }

    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    private func showInstructions() {
        let instructions = CameraOverlayView(frame: view.bounds)
        view.addSubview(instructions)
        instructions.showAndAutoDismiss()
    }

    @objc private func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        capturePhotoOutput.capturePhoto(with: settings, delegate: self)
    }

    @objc private func retakePhoto() {
        capturedImageView.isHidden = true
        retakeButton.isHidden = true
        continueButton.isHidden = true
        shutterButton.isHidden = false

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    @objc private func continueTapped() {
        guard let image = capturedImage else { return }
        let loadingVC = AnalysisLoadingViewController(image: image)
        loadingVC.modalPresentationStyle = .fullScreen
        present(loadingVC, animated: true)
    }


    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        if gesture.state == .changed {
            let maxZoomFactor = min(device.activeFormat.videoMaxZoomFactor, 3.0)
            let zoomFactor = min(max(1.0, gesture.scale), maxZoomFactor)
            do {
                try device.lockForConfiguration()
                device.videoZoomFactor = zoomFactor
                device.unlockForConfiguration()
            } catch {
                print("Zoom error: \(error)")
            }
        }
    }
}

// MARK: AVCapturePhotoCaptureDelegate
extension CustomCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data),
              let flippedImage = image.flippedHorizontally() else { return }

        capturedImage = flippedImage
        capturedImageView.image = flippedImage
        capturedImageView.isHidden = false
        retakeButton.isHidden = false
        continueButton.isHidden = false
        shutterButton.isHidden = true
        captureSession.stopRunning()
    }
}
extension UIImage {
    func flippedHorizontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: self.size.width, y: 0)
        context?.scaleBy(x: -1.0, y: 1.0)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flippedImage
    }
}
