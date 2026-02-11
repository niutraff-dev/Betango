import SwiftUI

struct Feature5CoordinatorView: View {

    @ObservedObject var coordinator: Feature5Coordinator

    var body: some View {
        NavigationStorableView(navigation: coordinator.navigation) {
            coordinator.showMain()
        }
    }
}
