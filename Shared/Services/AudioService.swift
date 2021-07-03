import AVFoundation
import Foundation

class AudioService: ObservableObject {

    private let service: AppService
    private let player = AVPlayer()

    init(service: AppService) {
        self.service = service
    }

    func setupSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        try session.setActive(true, options: [])
    }

    func stop() {
        player.pause()
        player.replaceCurrentItem(with: nil)
    }

    func play(endpoint: String) throws {
        stop()
        try setupSession()

        let item = AVPlayerItem(url: service.baseURL.appendingPathComponent(endpoint))
        player.replaceCurrentItem(with: item)
        player.play()
    }

}
