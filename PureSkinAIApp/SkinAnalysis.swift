//
//  SkinAnalysis.swift
//  PureSkinAIApp
//
//  Created by sude on 18.08.2025.
//

import Foundation
import UIKit

struct SkinAnalysis: Codable {
    let id: UUID
    let date: Date
    let score: Int
    let imageData: Data
    let resultText: String  
    
    init(score: Int, image: UIImage, resultText: String) {
        self.id = UUID()
        self.date = Date()
        self.score = score
        self.resultText = resultText
        self.imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
    }
}

