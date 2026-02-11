import AVFoundation

/// Воспроизводит один и тот же звук тика на каждый удар. Скорость задаётся интервалом вызовов, а не разными файлами.
final class MetronomeSoundPlayer {

    private var player: AVAudioPlayer?
    private let session = AVAudioSession.sharedInstance()

    init() {
        configureSession()
        loadSound()
    }

    private func configureSession() {
        try? session.setCategory(.playback, options: .mixWithOthers)
        try? session.setActive(true)
    }

    private func loadSound() {
        guard let url = Bundle.main.url(forResource: "metronome_tick", withExtension: "wav")
            ?? Bundle.main.url(forResource: "metronome_tick", withExtension: "mp3") else {
            return
        }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        player?.numberOfLoops = 0
    }

    /// Воспроизвести один тик. Вызывать на каждый удар — интервал задаётся снаружи (по BPM).
    func playTick() {
        player?.currentTime = 0
        player?.play()
    }
}
