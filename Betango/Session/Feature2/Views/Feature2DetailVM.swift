import SwiftUI
import Combine

@MainActor
final class Feature2DetailVM: ObservableObject {

    struct Output {
        let onBack: () -> Void
        let onSaveSuccess: () -> Void
    }
    
    @Published var settingsinfo: SettingsInfo

    var output: Output?
    
    private let service: Feature2Service
    private let existingRecord: SettingsInfo?

    var isEditing: Bool { existingRecord != nil }

    init(service: Feature2Service, existingRecord: SettingsInfo?) {
        self.service = service
        self.existingRecord = existingRecord
        self.settingsinfo = existingRecord ?? SettingsInfo.initialInfo
    }

    func onBackTapped() {
        output?.onBack()
    }
    
    func saveResult() {
        Task {
            await service.saveRecord(settingsinfo)
            await MainActor.run { output?.onSaveSuccess() }
        }
    }
}
