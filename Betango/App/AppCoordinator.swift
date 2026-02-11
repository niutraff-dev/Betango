import Foundation
import Combine
import Network

@MainActor
final class AppCoordinator: ObservableObject {

    enum ViewState {
        case session(SessionCoordinator)
        case webView(URL)
    }

    enum Overlay {
        case splash
    }

    @Published private(set) var viewState: ViewState?
    @Published var overlay: Overlay?

    private let appStatusService: Network.AppStatusServiceProtocol
    private let analyticsRepository: Network.AnalyticsRepositoryProtocol
    private let notificationsService: NotificationsService
    private var status: Network.AppStatus?
    private var statisticsUrl: URL?

    init(
        appStatusService: Network.AppStatusServiceProtocol,
        analyticsRepository: Network.AnalyticsRepositoryProtocol,
        notificationsService: NotificationsService
    ) {
        self.appStatusService = appStatusService
        self.analyticsRepository = analyticsRepository
        self.notificationsService = notificationsService
        self.overlay = .splash
    }

    convenience init() {
        self.init(
            appStatusService: NetworkServiceFactory.makeAppStatusService(),
            analyticsRepository: NetworkServiceFactory.makeAnalyticsRepository(),
            notificationsService: NotificationsService()
        )
    }

    func onAppear() async {
        async let statusResult = appStatusService.loadStatus()
        async let analytics = analyticsRepository.sendEvent()

        let (result, _) = await (statusResult, analytics)

        statisticsUrl = result.statisticsUrl
        handleStatus(result.status)
    }

    private func handleStatus(_ status: Network.AppStatus) {
        overlay = nil
        self.status = status
        handleNotifications(for: status)

        showMain()
    }

    private func handleNotifications(for status: Network.AppStatus) {
        Task {
            switch status {
            case .zero:
                await notificationsService.removeDailyNotifications()
            case .one:
                Task {
                    let granted = await notificationsService.requestAuthorization()
                    if granted {
                        await notificationsService.scheduleNotifications()
                    }
                }
            }
        }
    }

    private func showMain() {
        guard let status = status else { return }

        switch status {
        case .zero:
            showSession()
        case .one(let url):
            showWebView(with: url)
        }
    }

    private func showSession() {
        let coordinator = SessionCoordinator()
        viewState = .session(coordinator)
    }

    private func showWebView(with url: URL?) {
        guard let url = url else {
            showSession()
            return
        }
        viewState = .webView(url)
    }
}
