import SwiftUI
import Combine

@MainActor
final class Feature3DetailVM: ObservableObject {

    struct Output {
        let onBack: () -> Void
    }

    var output: Output?

    let type: Dictionary

    init(type: Dictionary) {
        self.type = type
    }

    func onBackTapped() {
        output?.onBack()
    }
}
