import SwiftUI
import Combine

final class Feature2CoordinatorNavigation: NavigationStorable {

    enum Screen: ScreenIdentifiable {
        case main(Feature2VM)
        case detail(Feature2DetailVM)
        case random(Feature2RandomVM)
        case myCombos(Feature2MyComboVM)
        case myComboDetail(Feature2MyComboDetailVM)
        case addMove(Feature2AddMoveVM)

        var screenID: ObjectIdentifier {
            switch self {
            case .main(let vm): return ObjectIdentifier(vm)
            case .detail(let vm): return ObjectIdentifier(vm)
            case .random(let vm): return ObjectIdentifier(vm)
            case .myCombos(let vm): return ObjectIdentifier(vm)
            case .myComboDetail(let vm): return ObjectIdentifier(vm)
            case .addMove(let vm): return ObjectIdentifier(vm)
            }
        }
    }

    @Published var path: NavigationPath = NavigationPath()

    @ViewBuilder
    func view(for screen: Screen) -> some View {
        switch screen {
        case .main(let vm):
            Feature2View(viewModel: vm)
        case .detail(let vm):
            Feature2DetailView(viewModel: vm)
        case .random(let vm):
            Feature2RandomView(viewModel: vm)
        case .myCombos(let vm):
            Feature2MyComboView(viewModel: vm)
        case .myComboDetail(let vm):
            Feature2MyComboDetailView(viewModel: vm)
        case .addMove(let vm):
            Feature2AddMoveView(viewModel: vm)
        }
    }
}
