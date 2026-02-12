import SwiftUI
import UIKit

struct SessionCoordinatorView: View {

    @ObservedObject var coordinator: SessionCoordinator

    @StateObject private var feature1Coordinator: Feature1Coordinator
    @StateObject private var feature2Coordinator: Feature2Coordinator
    @StateObject private var feature3Coordinator: Feature3Coordinator
    @StateObject private var feature4Coordinator: Feature4Coordinator
    @StateObject private var feature5Coordinator: Feature5Coordinator

    init(coordinator: SessionCoordinator) {
        self.coordinator = coordinator
        self._feature1Coordinator = StateObject(wrappedValue: coordinator.buildFeature1Coordinator())
        self._feature2Coordinator = StateObject(wrappedValue: coordinator.buildFeature2Coordinator())
        self._feature3Coordinator = StateObject(wrappedValue: coordinator.buildFeature3Coordinator())
        self._feature4Coordinator = StateObject(wrappedValue: coordinator.buildFeature4Coordinator())
        self._feature5Coordinator = StateObject(wrappedValue: coordinator.buildFeature5Coordinator())
    }

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            Feature1CoordinatorView(coordinator: feature1Coordinator)
                .tabItem {
                    Image(coordinator.selectedTab == .feature1 ? .selTab1 : .tab1)
                    Text("tab.feature1".localized())
                }
                .tag(SessionTab.feature1)
            
            Feature2CoordinatorView(coordinator: feature2Coordinator)
                .tabItem {
                    Image(coordinator.selectedTab == .feature2 ? .selTab2 : .tab2)
                    Text("tab.feature2".localized())
                }
                .tag(SessionTab.feature2)
            
            
            Feature4CoordinatorView(coordinator: feature4Coordinator)
                .tabItem {
                    Image(coordinator.selectedTab == .feature3 ? .selTba3: .tab3)
                    Text("tab.feature3".localized())
                }
                .tag(SessionTab.feature3)
            
            
            Feature3CoordinatorView(coordinator: feature3Coordinator)
                .tabItem {
                    Image(coordinator.selectedTab == .feature4 ? .selTab4: .tab4)
                    Text("tab.feature4".localized())
                }
                .tag(SessionTab.feature4)
            
            
            Feature5CoordinatorView(coordinator: feature5Coordinator)
                .tabItem {
                    Image(coordinator.selectedTab == .feature5 ? .selTab5: .tab5)
                    Text("tab.feature5".localized())
                }
                .tag(SessionTab.feature5)
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = UIColor.white
            
            UITabBar.appearance().unselectedItemTintColor = UIColor(Color.palette(.lightGrayColor))
            
            // Добавляем линию вверху TabBar
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.palette(.white))
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .tint(Color.palette(.orangeColor))
    }
}

#Preview {
    SessionCoordinatorView(coordinator: SessionCoordinator())
}
