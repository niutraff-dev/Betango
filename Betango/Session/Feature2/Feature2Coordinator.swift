import SwiftUI
import Combine

@MainActor
protocol Feature2CoordinatorElementsFactory {
    func feature2VM() -> Feature2VM
    func feature2DetailVM(existingRecord: SettingsInfo?) -> Feature2DetailVM
    func feature2RandomVM() -> Feature2RandomVM
    func feature2MyComboVM() -> Feature2MyComboVM
    func feature2MyComboDetailVM(combo: SavedRandomCombo?) -> Feature2MyComboDetailVM
    func feature2AddMoveVM(initialCombo: [Combo]) -> Feature2AddMoveVM
}

@MainActor
final class Feature2Coordinator: ObservableObject {

    let navigation: Feature2CoordinatorNavigation
    private let elementsFactory: Feature2CoordinatorElementsFactory
    private var _viewModel: Feature2VM?

    private var viewModel: Feature2VM {
        if let vm = _viewModel { return vm }
        let vm = elementsFactory.feature2VM()
        vm.output = .init(
            onDetail: { [weak self] in self?.showDetail(existingRecord: nil) },
            onEditRecord: { [weak self] record in self?.showDetail(existingRecord: record) },
            onRandom: { [weak self] in self?.showRandom() },
            onMyCombos: { [weak self] in self?.showMyCombos() }
        )
        _viewModel = vm
        return vm
    }

    init(
        navigation: Feature2CoordinatorNavigation,
        elementsFactory: Feature2CoordinatorElementsFactory
    ) {
        self.navigation = navigation
        self.elementsFactory = elementsFactory
    }

    func showMain() -> some View {
        navigation.view(for: .main(viewModel))
    }

    private func showDetail(existingRecord: SettingsInfo?) {
        let detailVM = elementsFactory.feature2DetailVM(existingRecord: existingRecord)
        detailVM.output = .init(
            onBack: { [weak self] in self?.navigation.navigateBack() },
            onSaveSuccess: { [weak self] in self?.navigation.navigateBack() }
        )
        navigation.navigateTo(.detail(detailVM))
    }

    private func showRandom() {
        let randomVM = elementsFactory.feature2RandomVM()
        randomVM.output = .init(
            onBack: { [weak self] in self?.navigation.navigateBack() },
            onSaveSuccess: { [weak self] in self?.navigation.navigateBack() }
        )
        navigation.navigateTo(.random(randomVM))
    }

    private func showMyCombos() {
        let myComboVM = elementsFactory.feature2MyComboVM()
        myComboVM.output = .init(
            onBack: { [weak self] in self?.navigation.navigateBack() },
            onSaveSuccess: { [weak self] in self?.navigation.navigateBack() },
            onComboSelected: { [weak self] combo in self?.showMyComboDetail(combo: combo) },
            onCreateCombo: { [weak self] in self?.showMyComboDetail(combo: nil) }
        )
        navigation.navigateTo(.myCombos(myComboVM))
    }

    private func showMyComboDetail(combo: SavedRandomCombo?) {
        let detailVM = elementsFactory.feature2MyComboDetailVM(combo: combo)
        detailVM.output = .init(
            onBack: { [weak self] in self?.navigation.navigateBack() },
            onDeleted: { [weak self] in self?.navigation.navigateBack() },
            onCreated: { [weak self] in self?.navigation.navigateBack() },
            onAddMove: { [weak self, weak detailVM] initialCombo in
                guard let self, let detailVM else { return }
                self.showAddMove(detailVM: detailVM, initialCombo: initialCombo)
            }
        )
        navigation.navigateTo(.myComboDetail(detailVM))
    }

    private func showAddMove(detailVM: Feature2MyComboDetailVM, initialCombo: [Combo]) {
        let addVM = elementsFactory.feature2AddMoveVM(initialCombo: initialCombo)
        addVM.output = .init(
            onBack: { [weak self] in self?.navigation.navigateBack() },
            onNext: { [weak self, weak detailVM] selected in
                detailVM?.applyMoves(selected)
                self?.navigation.navigateBack()
            }
        )
        navigation.navigateTo(.addMove(addVM))
    }
}
