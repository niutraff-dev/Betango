import Foundation

struct SettingsInfo: Identifiable, Codable {
    var id = UUID().uuidString
    var name: String
    var difficulty: Difficulty
    var lenght: Int
    var role: Role
    var focus: [Focus]
}

enum Difficulty: Codable {
    case beginner, intermediate, advanced
    
    var title: String {
        switch self {
        case .beginner:
            "Beginner"
        case .intermediate:
            "Intermediate"
        case .advanced:
            "Advanced"
        }
    }
}

enum Role: Codable {
    case leader, follower, both
    
    var title: String {
        switch self {
        case .leader:
            "Leader"
        case .follower:
            "Follower"
        case .both:
            "Both"
        }
    }
}

struct Focus: Identifiable, Codable {
    var id = UUID().uuidString
    var name: String
    var isSelected: Bool
}

extension SettingsInfo {
    static let initialInfo: SettingsInfo = .init(name: "", difficulty: .beginner, lenght: 0, role: .leader, focus: [
        Focus(name: "Footwork", isSelected: false),
        Focus(name: "Turns", isSelected: false),
        Focus(name: "Balance", isSelected: false),
        Focus(name: "Musicality", isSelected: false),
    ])
    
    var isValid: Bool {
        name.isEmpty
    }
}

struct Combo: Identifiable, Codable {
    var id = UUID().uuidString
    var name: String
}

/// Сохранённое рандомное комбо: имя + 4 шага.
struct SavedRandomCombo: Identifiable, Codable {
    var id = UUID().uuidString
    var name: String
    var combo: [Combo]
}

extension Combo {
    static let combo1: [Combo] = [
        Combo(name: "Ocho"),
        Combo(name: "Side step"),
        Combo(name: "Giro"),
        Combo(name: "Pause")
    ]
    
    static let combo2: [Combo] = [
        Combo(name: "Ocho"),
        Combo(name: "Ocho"),
        Combo(name: "Giro"),
        Combo(name: "Pause")
    ]
    
    static let combo3: [Combo] = [
        Combo(name: "Giro"),
        Combo(name: "Sacada"),
        Combo(name: "Gancho"),
        Combo(name: "Pause")
    ]
    
    static let combo4: [Combo] = [
        Combo(name: "Caminata"),
        Combo(name: "Giro"),
        Combo(name: "Colgada"),
        Combo(name: "Pause")
    ]
    
    static let combo5: [Combo] = [
        Combo(name: "Caminata"),
        Combo(name: "Side step"),
        Combo(name: "Cruzada"),
        Combo(name: "Pause")
    ]
    
    static let combo6: [Combo] = [
        Combo(name: "Side step"),
        Combo(name: "Molinete"),
        Combo(name: "Pivot"),
        Combo(name: "Pause")
    ]
    
    static let combo7: [Combo] = [
        Combo(name: "Molinete"),
        Combo(name: "Boleo"),
        Combo(name: "Parada"),
        Combo(name: "Adorno")
    ]
    
    static let combo8: [Combo] = [
        Combo(name: "Ocho"),
        Combo(name: "Sacada"),
        Combo(name: "Enganche"),
        Combo(name: "Pause")
    ]
    
    static let combo9: [Combo] = [
        Combo(name: "Side step"),
        Combo(name: "Ocho"),
        Combo(name: "Ocho"),
        Combo(name: "Pause")
    ]
    
    static let combo10: [Combo] = [
        Combo(name: "Caminata"),
        Combo(name: "Sacada"),
        Combo(name: "Giro"),
        Combo(name: "Pause")
    ]
    
    static let combo11: [Combo] = [
        Combo(name: "Ocho"),
        Combo(name: "Rebound"),
        Combo(name: "Boleo"),
        Combo(name: "Pause")
    ]
    
    static let combo12: [Combo] = [
        Combo(name: "Molinete"),
        Combo(name: "Rebound"),
        Combo(name: "Gancho"),
        Combo(name: "Adorno")
    ]
    
    static let combo13: [Combo] = [
        Combo(name: "Caminata"),
        Combo(name: "Pivot"),
        Combo(name: "Side step"),
        Combo(name: "Pause")
    ]
    
    static let combo14: [Combo] = [
        Combo(name: "Ocho"),
        Combo(name: "Side step"),
        Combo(name: "Parada"),
        Combo(name: "Adorno")
    ]
    
    static let combo15: [Combo] = [
        Combo(name: "Side step"),
        Combo(name: "Volcada"),
        Combo(name: "Pivot"),
        Combo(name: "Pause")
    ]

    /// Все 15 комбо для выбора случайного.
    static let allCombos: [[Combo]] = [
        combo1, combo2, combo3, combo4, combo5, combo6, combo7, combo8,
        combo9, combo10, combo11, combo12, combo13, combo14, combo15
    ]

    /// Все уникальные названия движений для экрана Add move.
    static var allMoveNames: [String] {
        var set = Set<String>()
        for combo in allCombos {
            for step in combo { set.insert(step.name) }
        }
        set.insert("Media Luna")
        set.insert("Back Ocho")
        set.insert("Open step")
        return set.sorted()
    }
}
