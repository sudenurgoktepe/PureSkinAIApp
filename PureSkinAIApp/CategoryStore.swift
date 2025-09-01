
import Foundation

struct CategoryStore {
    private static let key = "dynamicCategories"

    private static let defaultCategories: [String: [String]] = [
        "Temizleme": [
            "Yağ Bazlı Temizleme", "Su Bazlı Temizleme", "Misel Su ile Temizleme",
            "Nemlendirici Temizleyici Uygula", "Temizleme Sütü Uygula",
            "Temizleme Balmi Uygula", "Temizleme Kremi Uygula", "Köpük Temizleyici"
        ],
        "Toner/Spray": [
            "Hassas Tonik", "Nem Spreyi", "Peeling Tonik(AHA/BHA)", "Sıkılaştırıcı Tonik"
        ],
        "Tedavi": [
            "Akne Karşıtı", "Leke Serumu", "C Vitamini Serumu", "Retinol",
            "Hyaluronik Asit", "Niacinamide", "Sivilce Jeli",
            "Leke Açıcı Serum", "Göz Altı Serumu"
        ],
        "Nemlendirici": [
            "Hafif Nemlendirici Jel", "Yoğun Nemlendirici Krem", "Uyku Maskesi", "Göz Kremi"
        ],
        "Koruma": [
            "GKF 50+", "GKF 30+", "SPF Stick"
        ],
        "Diğer": [
            "Yüz Masajı", "Maske", "Gua Sha"
        ]
    ]

    static func load() -> [String: [String]] {
        var categories = defaultCategories

        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([String: [String]].self, from: data) {
            
            for (category, items) in decoded {
                var merged = categories[category] ?? []
                for item in items where !merged.contains(item) {
                    merged.append(item)
                }
                categories[category] = merged
            }
        }

        return categories
    }

    static func save(_ dict: [String: [String]]) {
        if let encoded = try? JSONEncoder().encode(dict) {
            UserDefaults.standard.set(encoded, forKey: key)
            NotificationCenter.default.post(name: Notification.Name("CategoryUpdated"), object: nil)
        }
    }

    static func addProduct(category: String, product: String) {
        var current = load()
        var items = current[category] ?? []
        if !items.contains(product) {
            items.append(product)
        }
        current[category] = items
        save(current)
    }
}
