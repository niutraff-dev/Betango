import Foundation
import Combine

enum ViewState {
    case result, create, edit
}

@MainActor
final class Feature1VM: ObservableObject {

    struct Output {
        let onDetail: () -> Void
        let onEditRecord: (CalendarInfo) -> Void
    }

    @Published private(set) var records: [CalendarInfo] = []
    @Published var viewState: ViewState = .result

    private let service: Feature1Service
    private var cancellables = Set<AnyCancellable>()

    var output: Output?

    init(service: Feature1Service) {
        self.service = service
        subscribeToRecords()
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

    func onDetailTapped() {
        output?.onDetail()
    }

    func onRecordTapped(_ record: CalendarInfo) {
        output?.onEditRecord(record)
    }
}
