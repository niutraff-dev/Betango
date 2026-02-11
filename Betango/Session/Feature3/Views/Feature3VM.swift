import Foundation
import Combine

@MainActor
final class Feature3VM: ObservableObject {
    
    struct Output {
        let onDetail: (Dictionary) -> Void
    }

    var output: Output?

    var allPlayers: [Dictionary] = [.type1, .type2, .type3, .type4, .type5, .type6, .type7, .type8, .type9, .type10, .type11, .type12, .type13, .type14, .type15, .type16, .type17, .type18, .type19, .type20, .type21, .type22, .type23, .type24, .type25]
    
    
    func onTapped(_ type: Dictionary) {
        output?.onDetail(type)
    }
}
