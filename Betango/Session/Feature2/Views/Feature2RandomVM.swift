import Foundation
import Combine

@MainActor
final class Feature2RandomVM: ObservableObject {

    struct Output {
        let onBack: () -> Void
        let onSaveSuccess: () -> Void
    }

    var output: Output?

    @Published var currentCombo: [Combo]
    @Published var isSaveMode: Bool = false
    @Published var saveName: String = ""

    @Published var timerVM: TimerVM?

    private let service: Feature2Service

    var isSaveButtonEnabled: Bool { !saveName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    init(service: Feature2Service) {
        self.service = service
        self.currentCombo = Combo.allCombos.randomElement() ?? Combo.combo1
    }

    func onBackTapped() {
        if timerVM != nil {
            timerVM = nil
        } else {
            output?.onBack()
        }
    }

    func shuffle() {
        currentCombo = Combo.allCombos.randomElement() ?? Combo.combo1
    }

    func openSaveMode() {
        isSaveMode = true
        saveName = ""
    }

    func closeSaveMode() {
        isSaveMode = false
        saveName = ""
    }

    func saveCombo() {
        guard isSaveButtonEnabled else { return }
        let name = saveName.trimmingCharacters(in: .whitespacesAndNewlines)
        let item = SavedRandomCombo(name: name, combo: currentCombo)
        Task {
            try? await service.saveRandomCombo(item)
            await MainActor.run {
                closeSaveMode()
                output?.onSaveSuccess()
            }
        }
    }

    func openTimer() {
        let vm = TimerVM()
        vm.output = .init(onClose: { [weak self] in self?.timerVM = nil })
        timerVM = vm
    }
}
