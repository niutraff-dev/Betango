import Foundation
import Combine

@MainActor
final class Feature2MyComboVM: ObservableObject {
    
    struct Output {
        let onBack: () -> Void
        let onSaveSuccess: () -> Void
        let onComboSelected: (SavedRandomCombo) -> Void
        let onCreateCombo: () -> Void
    }
    
    var output: Output?
    
    @Published private(set) var myCombos: [SavedRandomCombo] = []

    private let service: Feature2Service
    private var cancellables = Set<AnyCancellable>()
    
    init(service: Feature2Service) {
        self.service = service
        subscribeToMyCombos()
    }
    
    private func subscribeToMyCombos() {
        service.myCombosPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.myCombos = list
            }
            .store(in: &cancellables)
    }
    
    func onBackTapped() {
        output?.onBack()
    }

    func onComboTapped(_ combo: SavedRandomCombo) {
        output?.onComboSelected(combo)
    }

    func onCreateComboTapped() {
        output?.onCreateCombo()
    }
}
