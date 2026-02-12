import SwiftUI
import SwiftData
import UIKit

@main
struct BetangoApp: App {

    @StateObject
    private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: coordinator)
        }
    }
}
