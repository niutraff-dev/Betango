import SwiftUI
import Combine

final class Feature5CoordinatorNavigation: NavigationStorable {

    enum Screen: ScreenIdentifiable {
        case main(Feature5VM)

        var screenID: ObjectIdentifier {
            switch self {
            case .main(let vm):
                return ObjectIdentifier(vm)
            }
        }
    }

    @Published var path: NavigationPath = NavigationPath()

    @ViewBuilder
    func view(for screen: Screen) -> some View {
        switch screen {
        case .main(let vm):
            Feature5View(viewModel: vm)
        }
    }
}
