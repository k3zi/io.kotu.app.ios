import Combine
import Foundation
import SwiftUI

@MainActor
class SearchModel: ObservableObject {

    typealias Service = DictionaryService & SearchService

    @Published var request: SearchRequest
    @Published var results = [SearchResult]()
    @Published var totalResults = 0
    @Published var isLoading = false

    private let service: Service
    private var cancellables = Set<AnyCancellable>()
    private let loadNextPageSubject = PassthroughSubject<Void, Never>()
    private let canLoadNextPageSubject = CurrentValueSubject<Bool, Never>(false)

    var canLoadNextPage: Bool { !results.isEmpty && canLoadNextPageSubject.value }

    init(service s: Service) {
        service = s
        request = SearchRequest(query: "", type: .words)
        $request
            .handleEvents(receiveOutput: { [unowned self] request in
                self.canLoadNextPageSubject.send(true)
                self.totalResults = 0
                self.results = []
                self.isLoading = !request.query.isEmpty
            })
            .filter { !$0.query.isEmpty }
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { [unowned self] _ in
                self.isLoading = true
            })
            .map { [unowned self] request in
                self.loadNextPageSubject
                    .prepend(())
                    .throttle(for: .seconds(2), scheduler: RunLoop.main, latest: true)
                    .scan(0) { prev, _ in prev + 1 }
                    .map { PaginatedSearchRequest(request: request, page: $0) }
                    .asyncMap { [unowned self] in
                        try await service.search(request: $0.request, page: $0.page)
                    }
                    .handleEvents(receiveOutput: { [unowned self] result in
                        if !result.canLoadNextPage {
                            self.canLoadNextPageSubject.send(false)
                        }
                        self.totalResults = result.metadata.total
                        self.isLoading = false
                    })
                    .map(\.items)
                    .scan([SearchResult](), +)
                    .replaceError(with: [])
            }
            .switchToLatest()
            .sink { [unowned self] results in
                withAnimation {
                    self.results = results
                }
            }
            .store(in: &cancellables)
    }

    func loadNextPage() {
        loadNextPageSubject.send()
    }

    func dictionaryIcon(for result: SearchWordResult) -> URL {
        service.dictionaryIcon(forID: result.dictionary.id)
    }

}
