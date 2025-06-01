

import Foundation

enum Gender: Int,CaseIterable {
    case female = 0
    case male = 1
}
extension Gender {
    var displayName: String {
        switch self {
        case .female: return "Kadın"
        case .male: return "Erkek"
        }
    }

    static var allTitles: [String] {
        return [Gender.female, Gender.male].map { $0.displayName }
    }
}

enum AgeRange: Int,CaseIterable {
    case range13to17 = 0
    case range18to24 = 1
    case range25to34 = 2
    case range35to44 = 3
    case range45to54 = 4
    case range55plus = 5
    case none = -1
}
extension AgeRange {
    var displayName: String {
        switch self {
        case .range13to17: return "13-17"
        case .range18to24: return "18-24"
        case .range25to34: return "25-34"
        case .range35to44: return "35-44"
        case .range45to54: return "45-54"
        case .range55plus: return "55+"
        case .none: return "Belirtilmemiş"
        }
    }
    static var allTitles: [String] {
            return AgeRange.allCases
                .filter { $0 != .none }
                .map { $0.displayName }
        }
}


enum EditingField {
    case age
    case gender
}

enum SkinType: Int,CaseIterable {
    case normal = 0
    case dry = 1
    case oily = 2
    case combination = 3
    case sensitive = 4
}
extension SkinType {
    var displayName: String {
        switch self {
        case .normal: return "Normal"
        case .dry: return "Kuru"
        case .oily: return "Yağlı"
        case .combination: return "Karma"
        case .sensitive: return "Hassas"
        }
    }

    static var allTitles: [String] {
        return SkinType.allCases.map { $0.displayName }
    }
}


enum SkinSensitivity: Int,CaseIterable {
    case notSensitive = 0
    case slightlySensitive = 1
    case moderatelySensitive = 2
    case verySensitive = 3
}
extension SkinSensitivity {
    var displayName: String {
        switch self {
        case .notSensitive: return "Hassas Değil"
        case .slightlySensitive: return "Biraz Hassas"
        case .moderatelySensitive: return "Orta Hassas"
        case .verySensitive: return "Çok Hassas"
        }
    }

    static var allTitles: [String] {
        return SkinSensitivity.allCases.map { $0.displayName }
    }
}



enum SkinProblem: Int {
    case dullSkin = 0
    case sensitiveSkin = 1
    case veryDrySkin = 2
    case acneScars = 3
    case redness = 4
    case pores = 5
    case unevenTexture = 6
    case fineLines = 7
    case wrinkles = 8
    case lossOfElasticity = 9
    case swelling = 10
    case darkCircles = 11

    var title: String {
        switch self {
        case .dullSkin: return "Donuk Cilt"
        case .sensitiveSkin: return "Hassas Cilt"
        case .veryDrySkin: return "Çok Kuru Cilt"
        case .acneScars: return "Akne İzleri"
        case .redness: return "Kızarıklık"
        case .pores: return "Gözenekler"
        case .unevenTexture: return "Düzensiz Doku"
        case .fineLines: return "İnce Çizgiler"
        case .wrinkles: return "Kırışıklıklar"
        case .lossOfElasticity: return "Esneklik Kaybı"
        case .swelling: return "Şişkinlik"
        case .darkCircles: return "Göz Altı Morlukları"
        }
    }
}

extension SkinProblem: CaseIterable {
    static var allTitles: [String] {
        return SkinProblem.allCases.map { $0.title }
    }
}

enum SkinCondition: Int, CaseIterable {
    case eczema = 0
    case rosacea = 1
    case psoriasis = 2
    case hives = 3

    var title: String {
        switch self {
        case .eczema: return "Egzama"
        case .rosacea: return "Rozasea"
        case .psoriasis: return "Sedef hastalığı"
        case .hives: return "Kurdeşen"
        }
    }
    static var allTitles: [String] {
            return SkinCondition.allCases.map { $0.title }
        }
}
