import Foundation

struct CalendarInfo: Identifiable, Codable {
    var id = UUID().uuidString
    var date: Date
    var time: Date
    var name: String
}

extension CalendarInfo {
    static let initialData: CalendarInfo = .init(date: .now, time: .now, name: "")
    
     var isValid: Bool {
         name.isEmpty
    }
}
