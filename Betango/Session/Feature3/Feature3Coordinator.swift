import SwiftUI
import Combine

@MainActor
protocol Feature3CoordinatorElementsFactory {
    func feature3VM() -> Feature3VM
    func feature3DetailVM(type: Dictionary) -> Feature3DetailVM
}

@MainActor
final class Feature3Coordinator: ObservableObject {

    let navigation: Feature3CoordinatorNavigation
    private let elementsFactory: Feature3CoordinatorElementsFactory
    private var _viewModel: Feature3VM?

    private var viewModel: Feature3VM {
        if let vm = _viewModel { return vm }
        let vm = elementsFactory.feature3VM()
        vm.output = .init(
            onDetail: { [weak self] type in self?.showDetail(type: type) }
        )
        _viewModel = vm
        return vm
    }

    init(
        navigation: Feature3CoordinatorNavigation,
        elementsFactory: Feature3CoordinatorElementsFactory
    ) {
        self.navigation = navigation
        self.elementsFactory = elementsFactory
    }

    func showMain() -> some View {
        navigation.view(for: .main(viewModel))
    }

    private func showDetail(type: Dictionary) {
        let detailVM = elementsFactory.feature3DetailVM(type: type)
        detailVM.output = .init(
            onBack: { [weak self] in self?.navigation.navigateBack() }
        )
        navigation.navigateTo(.detail(detailVM))
    }
}
