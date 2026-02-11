import Foundation
import Combine

@MainActor
final class TimerVM: ObservableObject {

    struct Output {
        let onClose: () -> Void
    }

    var output: Output?

    @Published var timerPreset: TimerPreset? = nil
    @Published var timerTotalSeconds: Int = 0
    @Published var timerRemainingSeconds: Int = 0
    @Published var isTimerRunning: Bool = false

    private var timerTask: Task<Void, Never>?

    enum TimerPreset: Int, CaseIterable {
        case min5 = 5
        case min10 = 10
        case min15 = 15
        var title: String { "\(rawValue) min" }
        var seconds: Int { rawValue * 60 }
    }

    var isStartEnabled: Bool { timerTotalSeconds > 0 && !isTimerRunning }
    var timerProgress: Double {
        guard timerTotalSeconds > 0 else { return 0 }
        return 1.0 - Double(timerRemainingSeconds) / Double(timerTotalSeconds)
    }

    func onBackTapped() {
        stopTimer()
        output?.onClose()
    }

    func selectTimerPreset(_ preset: TimerPreset) {
        timerPreset = preset
        timerTotalSeconds = preset.seconds
        timerRemainingSeconds = preset.seconds
    }

    func timerPlus() {
        timerTotalSeconds = min(60 * 60, timerTotalSeconds + 60)
        if !isTimerRunning { timerRemainingSeconds = timerTotalSeconds }
    }

    func timerMinus() {
        timerTotalSeconds = max(0, timerTotalSeconds - 60)
        if !isTimerRunning { timerRemainingSeconds = timerTotalSeconds }
        if timerTotalSeconds == 0 { timerPreset = nil }
    }

    func startTimer() {
        guard timerTotalSeconds > 0 else { return }
        isTimerRunning = true
        timerRemainingSeconds = timerTotalSeconds
        startTimerTick()
    }

    func stopTimer() {
        isTimerRunning = false
        timerTask?.cancel()
        timerTask = nil
    }

    func finishTimer() {
        stopTimer()
        timerTotalSeconds = 0
        timerRemainingSeconds = 0
        timerPreset = nil
        output?.onClose()
    }

    private func startTimerTick() {
        timerTask?.cancel()
        timerTask = Task { [weak self] in
            guard let self else { return }
            while timerRemainingSeconds > 0, !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await MainActor.run {
                    if self.isTimerRunning, self.timerRemainingSeconds > 0 {
                        self.timerRemainingSeconds -= 1
                        if self.timerRemainingSeconds == 0 {
                            self.stopTimer()
                        }
                    }
                }
            }
        }
    }

    func timerFormatted(_ total: Int) -> String {
        let m = total / 60
        let s = total % 60
        return String(format: "%02d:%02d", m, s)
    }
}
