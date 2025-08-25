//
//  SkinAnalysisStore.swift
//  PureSkinAIApp
//
//  Created by sude on 18.08.2025.
//

import Foundation

class SkinAnalysisStore {
    private static let key = "skin_analysis_history"
    
    /// Kaydetme
    static func save(_ analysis: SkinAnalysis) {
        var list = load()
        list.insert(analysis, at: 0) // en yeni başa eklenir
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    /// Okuma
    static func load() -> [SkinAnalysis] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let list = try? JSONDecoder().decode([SkinAnalysis].self, from: data) else {
            return []
        }
        return list
    }
    
    static func delete(_ analysis: SkinAnalysis) {
        var list = load()
        list.removeAll { $0.id == analysis.id }
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

}

