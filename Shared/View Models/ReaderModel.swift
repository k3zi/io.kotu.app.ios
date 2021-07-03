import Combine
import Foundation
import SwiftUI

@MainActor
class ReaderModel: ObservableObject {

    typealias Service = MediaService

    @Published var isLoading = false
    @Published var displayOptions = true
    @Published var input = ""
    @Published var text = ""

    private let service: Service
    private var cancellables = Set<AnyCancellable>()

    init(service s: Service) {
        service = s

        $input
            .removeDuplicates()
            .handleEvents(receiveOutput: { [unowned self] input in
                guard input.isEmpty else { return }
                self.isLoading = false
                self.text = ""
            })
            .filter { !$0.isEmpty }
            .asyncMap { [unowned self] in
                if let url = URL(string: $0) {
                    await self.load(url: url)
                } else {
                    await self.load(text: text)
                }
            }
            .replaceError(with: ())
            .sink { _ in }
            .store(in: &cancellables)
    }

    func load(url: URL) async {
        if let session = await service.mediaReaderSession(forURL: url) {
            return await load(session: session)
        }

        // TODO
    }

    func load(text: String) async {
        // TODO
    }

    func load(session: MediaReaderSession) async {
        // TODO
    }

}
