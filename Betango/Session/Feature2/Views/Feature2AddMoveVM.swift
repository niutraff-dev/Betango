import Foundation
import Combine

@MainActor
final class Feature2AddMoveVM: ObservableObject {

    struct Output {
        let onBack: () -> Void
        let onNext: ([Combo]) -> Void
    }

    var output: Output?

    @Published var selectedNames: Set<String>

    private let allMoveNames = Combo.allMoveNames

    var sortedMoveNames: [String] { allMoveNames }

    init(initialCombo: [Combo]) {
        self.selectedNames = Set(initialCombo.map(\.name))
    }

    func isSelected(_ name: String) -> Bool {
        selectedNames.contains(name)
    }

    func toggle(_ name: String) {
        if selectedNames.contains(name) {
            selectedNames.remove(name)
        } else {
            selectedNames.insert(name)
        }
    }

    func onBackTapped() {
        output?.onBack()
    }

    func onNextTapped() {
        let combo = selectedNames
            .intersection(Set(allMoveNames))
            .sorted(by: { allMoveNames.firstIndex(of: $0)! < allMoveNames.firstIndex(of: $1)! })
            .map { Combo(name: $0) }
        output?.onNext(combo)
    }
}
