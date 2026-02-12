import Foundation
import Combine

@MainActor
final class Feature2VM: ObservableObject {

    struct Output {
        let onDetail: () -> Void
        let onEditRecord: (SettingsInfo) -> Void
        let onRandom: () -> Void
        let onMyCombos: () -> Void
    }

    var output: Output?
    
    @Published private(set) var records: [SettingsInfo] = []
    @Published private(set) var myCombos: [SavedRandomCombo] = []
    
    private let service: Feature2Service
    private var cancellables = Set<AnyCancellable>()

    init(service: Feature2Service) {
        self.service = service
        subscribeToRecords()
        subscribeToMyCombos()
    }

    private func subscribeToRecords() {
        service.recordsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let info):
                    self?.records = info
                case .failure(let error):
                    print(error.errorDescription ?? "Unknown error")
                }
            }
            .store(in: &cancellables)
    }

    private func subscribeToMyCombos() {
        service.myCombosPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.myCombos = list
            }
            .store(in: &cancellables)
    }
    
    func onDetailTapped() {
        output?.onDetail()
    }

    func onRandomTapped() {
        output?.onRandom()
    }

    func onMyCombosTapped() {
        output?.onMyCombos()
    }

    func onRecordTapped(_ record: SettingsInfo) {
        output?.onEditRecord(record)
    }
}
