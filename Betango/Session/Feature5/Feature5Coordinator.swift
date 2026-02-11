import SwiftUI
import Combine

@MainActor
protocol Feature5CoordinatorElementsFactory {
    func feature5VM() -> Feature5VM
}

@MainActor
final class Feature5Coordinator: ObservableObject {

    let navigation: Feature5CoordinatorNavigation
    private let elementsFactory: Feature5CoordinatorElementsFactory
    private var _viewModel: Feature5VM?

    private var viewModel: Feature5VM {
        if let vm = _viewModel { return vm }
        let vm = elementsFactory.feature5VM()
        _viewModel = vm
        return vm
    }

    init(
        navigation: Feature5CoordinatorNavigation,
        elementsFactory: Feature5CoordinatorElementsFactory
    ) {
        self.navigation = navigation
        self.elementsFactory = elementsFactory
    }

    func showMain() -> some View {
        navigation.view(for: .main(viewModel))
    }
}
