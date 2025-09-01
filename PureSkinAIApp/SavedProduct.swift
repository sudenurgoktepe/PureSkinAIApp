
import Foundation
import UIKit

struct SavedProduct: Codable, Equatable {
    var id: UUID
    var name: String
    var imageData: Data
    var category: String?
    var descriptionText: String?
    var isInRoutine: Bool
}

enum ProductStore {
    private static let key = "saved_products"
    
    static func load() -> [SavedProduct] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([SavedProduct].self, from: data) else {
            return []
        }
        return decoded
    }
    
    static func save(_ product: SavedProduct) {
        var current = load()
        current.append(product)
        save(current)
    }
    
    static func save(_ products: [SavedProduct]) {
        if let encoded = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    static func delete(_ product: SavedProduct) {
        var current = load()
        current.removeAll { $0.id == product.id }
        save(current)
    }
    
    static func update(_ product: SavedProduct) {
        var products = load()
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
            save(products)  
        }
    }
}
