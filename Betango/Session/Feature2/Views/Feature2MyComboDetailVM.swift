import Foundation
import Combine

@MainActor
final class Feature2MyComboDetailVM: ObservableObject {

    struct Output {
        let onBack: () -> Void
        let onDeleted: () -> Void
        let onCreated: () -> Void
        let onAddMove: ([Combo]) -> Void
    }

    var output: Output?

    @Published var combo: SavedRandomCombo?
    @Published var isCreateMode: Bool = false
    @Published var isEditMode: Bool = false
    @Published var editName: String = ""
    @Published var editCombo: [Combo] = []
    @Published var showDeleteAlert: Bool = false
    @Published var timerVM: TimerVM?

    private let service: Feature2Service

    var isSaveEnabled: Bool { !editName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    init(combo: SavedRandomCombo?, service: Feature2Service) {
        self.combo = combo
        self.service = service
        self.isCreateMode = (combo == nil)
        self.isEditMode = (combo == nil)
        self.editName = combo?.name ?? ""
        self.editCombo = combo?.combo ?? []
    }

    func onBackTapped() {
        if timerVM != nil {
            timerVM = nil
        } else {
            output?.onBack()
        }
    }

    func openTimer() {
        let vm = TimerVM()
        vm.output = .init(onClose: { [weak self] in self?.timerVM = nil })
        timerVM = vm
    }

    func deleteTapped() {
        showDeleteAlert = true
    }

    func confirmDelete() {
        showDeleteAlert = false
        guard let id = combo?.id else { return }
        Task {
            try? await service.deleteRandomCombo(id: id)
            await MainActor.run { output?.onDeleted() }
        }
    }

    func cancelDelete() {
        showDeleteAlert = false
    }

    func editTapped() {
        guard let c = combo else { return }
        isEditMode = true
        editName = c.name
        editCombo = c.combo
    }

    func openAddMove() {
        output?.onAddMove(editCombo)
    }

    func applyMoves(_ moves: [Combo]) {
        editCombo = moves
    }

    func saveTapped() {
        guard isSaveEnabled else { return }
        let name = editName.trimmingCharacters(in: .whitespacesAndNewlines)
        if isCreateMode {
            let newCombo = SavedRandomCombo(name: name, combo: editCombo)
            Task {
                try? await service.saveRandomCombo(newCombo)
                await MainActor.run { output?.onCreated() }
            }
        } else if var existing = combo {
            existing.name = name
            existing.combo = editCombo
            combo = existing
            Task {
                try? await service.saveRandomCombo(existing)
                await MainActor.run { isEditMode = false }
            }
        }
    }
}
