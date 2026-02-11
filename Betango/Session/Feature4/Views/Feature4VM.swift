import Foundation
import Combine

@MainActor
final class Feature4VM: ObservableObject {

    enum MetronomeState {
        case idle
        case ready
        case playing
    }

    static let tempos = [80, 100, 120]

    @Published private(set) var state: MetronomeState = .idle
    @Published var selectedTempo: Int?
    @Published var arrowAngle: Double = 0

    private var beatTask: Task<Void, Never>?
    private let soundPlayer = MetronomeSoundPlayer()

    var isStartEnabled: Bool {
        switch state {
        case .idle: return false
        case .ready, .playing: return true
        }
    }

    var isPlaying: Bool { state == .playing }

    func selectTempo(_ bpm: Int) {
        guard Self.tempos.contains(bpm) else { return }
        selectedTempo = bpm
        switch state {
        case .idle:
            state = .ready
        case .ready, .playing:
            break
        }
    }

    func start() {
        guard state == .ready, let bpm = selectedTempo else { return }
        state = .playing
        startBeatTask()
    }

    func stop() {
        beatTask?.cancel()
        beatTask = nil
        state = .idle
        selectedTempo = nil
        arrowAngle = 0
    }

    func toggleStartStop() {
        switch state {
        case .ready:
            start()
        case .playing:
            stop()
        case .idle:
            break
        }
    }

    private func startBeatTask() {
        beatTask?.cancel()
        beatTask = Task { [weak self] in
            guard let self else { return }
            var isLeft = true
            while !Task.isCancelled {
                let bpm = await self.selectedTempo ?? 80
                let interval = 60.0 / Double(bpm)
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
                guard !Task.isCancelled else { break }
                await MainActor.run {
                    guard self.state == .playing else { return }
                    isLeft.toggle()
                    self.arrowAngle = isLeft ? -15 : 15
                    self.soundPlayer.playTick()
                }
            }
        }
    }
}
