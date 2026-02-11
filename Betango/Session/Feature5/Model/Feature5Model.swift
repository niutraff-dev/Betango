import Foundation

struct SettingsData: Identifiable {
    var id = UUID()
    var titel: String
    var link: URL
}

struct AppInfo {
    struct URLs {
        static let privacyLink = URL(string: "https://www.freeprivacypolicy.com/live/d4ae818c-6c5b-4b80-9112-3cf96520d0da")!
        static let termsLink = URL(string: "https://www.freeprivacypolicy.com/live/ba323926-f924-4a64-b590-82d6563f0ba5")!
        static let infoLink = URL(string: "https://landing.betango.info")!
    }
}
