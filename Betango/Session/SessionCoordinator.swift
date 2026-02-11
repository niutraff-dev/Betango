import Foundation
import Combine

enum SessionTab: Hashable {
    case feature1
    case feature2
    case feature3
    case feature4
    case feature5
}

@MainActor
protocol SessionCoordinatorElementsFactory:
    Feature1CoordinatorElementsFactory,
    Feature2CoordinatorElementsFactory,
    Feature3CoordinatorElementsFactory,
    Feature4CoordinatorElementsFactory,
    Feature5CoordinatorElementsFactory {}

@MainActor
final class SessionCoordinator: ObservableObject {

    @Published var selectedTab: SessionTab = .feature1
    private let notificationsService: NotificationsService
    private let feature1Service: Feature1Service
    private let feature2Service: Feature2Service
    private var hasRequestedNotifications = false

    init(notificationsService: NotificationsService, feature1Service: Feature1Service, feature2Service: Feature2Service) {
        self.notificationsService = notificationsService
        self.feature1Service = feature1Service
        self.feature2Service = feature2Service
    }

    convenience init() {
        self.init(notificationsService: NotificationsService(), feature1Service: Feature1Service(), feature2Service: Feature2Service())
    }

    func buildFeature1Coordinator() -> Feature1Coordinator {
        Feature1Coordinator(
            navigation: Feature1CoordinatorNavigation(),
            elementsFactory: self
        )
    }

    func buildFeature2Coordinator() -> Feature2Coordinator {
        Feature2Coordinator(
            navigation: Feature2CoordinatorNavigation(),
            elementsFactory: self
        )
    }

    func buildFeature3Coordinator() -> Feature3Coordinator {
        Feature3Coordinator(
            navigation: Feature3CoordinatorNavigation(),
            elementsFactory: self
        )
    }
    
    func buildFeature4Coordinator() -> Feature4Coordinator {
        Feature4Coordinator(
            navigation: Feature4CoordinatorNavigation(),
            elementsFactory: self
        )
    }
    
    func buildFeature5Coordinator() -> Feature5Coordinator {
        Feature5Coordinator(
            navigation: Feature5CoordinatorNavigation(),
            elementsFactory: self
        )
    }
}

extension SessionCoordinator: Feature1CoordinatorElementsFactory {
    func feature1VM() -> Feature1VM {
        Feature1VM(service: feature1Service)
    }

    func feature1DetailVM(existingRecord: CalendarInfo?) -> Feature1DetailVM {
        Feature1DetailVM(service: feature1Service, existingRecord: existingRecord)
    }
}

extension SessionCoordinator: Feature2CoordinatorElementsFactory {
    func feature2VM() -> Feature2VM {
        Feature2VM(service: feature2Service)
    }

    func feature2DetailVM(existingRecord: SettingsInfo?) -> Feature2DetailVM {
        Feature2DetailVM(service: feature2Service, existingRecord: existingRecord)
    }

    func feature2RandomVM() -> Feature2RandomVM {
        Feature2RandomVM(service: feature2Service)
    }

    func feature2MyComboVM() -> Feature2MyComboVM {
        Feature2MyComboVM(service: feature2Service)
    }

    func feature2MyComboDetailVM(combo: SavedRandomCombo?) -> Feature2MyComboDetailVM {
        Feature2MyComboDetailVM(combo: combo, service: feature2Service)
    }

    func feature2AddMoveVM(initialCombo: [Combo]) -> Feature2AddMoveVM {
        Feature2AddMoveVM(initialCombo: initialCombo)
    }
}

extension SessionCoordinator: Feature3CoordinatorElementsFactory {
    func feature3VM() -> Feature3VM {
        Feature3VM()
    }

    func feature3DetailVM(type: Dictionary) -> Feature3DetailVM {
        Feature3DetailVM(type: type)
    }
}

extension SessionCoordinator: Feature4CoordinatorElementsFactory {
    func feature4VM() -> Feature4VM {
        Feature4VM()
    }
}

extension SessionCoordinator: Feature5CoordinatorElementsFactory {
    func feature5VM() -> Feature5VM {
        Feature5VM()
    }
}
