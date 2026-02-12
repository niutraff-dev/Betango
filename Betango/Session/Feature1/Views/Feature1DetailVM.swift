import SwiftUI
import Combine

@MainActor
final class Feature1DetailVM: ObservableObject {

    struct Output {
        let onBack: () -> Void
        let onSaveSuccess: () -> Void
    }

    var output: Output?

    @Published var calendarInfo: CalendarInfo

    private let service: Feature1Service
    private let existingRecord: CalendarInfo?

    var isEditing: Bool { existingRecord != nil }

    init(service: Feature1Service, existingRecord: CalendarInfo?) {
        self.service = service
        self.existingRecord = existingRecord
        self.calendarInfo = existingRecord ?? CalendarInfo(date: Date(), time: Date(), name: "")
    }

    func onBackTapped() {
        output?.onBack()
    }

    func saveResult() {
        Task {
            await service.saveRecord(calendarInfo)
            await MainActor.run { output?.onSaveSuccess() }
        }
    }
}
