import Foundation
import Kumo

class AppService: ObservableObject {

    let baseURL = URL(string: "https://kotu.io/api")!
    private lazy var service = Service(baseURL: baseURL)
    private lazy var blobCache = BlobCache(using: service)

}

extension AppService: AsyncImageLoader {
    func data(for url: URL) async throws -> Data? {
        try await blobCache.fetch(from: url).single()
    }
}

extension AppService: DictionaryService {

    func dictionaryIcon(forID id: UUID) -> URL {
        baseURL.appendingPathComponent("dictionary/icon/\(id)")
    }

    func dictionaryURL(for searchResult: SearchWordResult) -> URL? {
        let preURL: URL
        if let entry = searchResult.entry {
            preURL = baseURL.appendingPathComponent("dictionary/entry/\(entry.id)")
        } else {
            preURL = baseURL.appendingPathComponent("dictionary/entry/\(searchResult.dictionary.id)/\(searchResult.entryIndex)")
        }
        var urlComponents = URLComponents(url: preURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            .init(name: "forceHorizontalText", value: "true"),
            .init(name: "forceDarkCSS", value: "true")
        ]
        return urlComponents?.url
    }

}

extension AppService: LoginService {

    func login(withUsername username: String, password: String) async throws -> User {
        try await service.perform(HTTP.Request.post("auth/login").body([
            "username": username,
            "password": password
        ])).single()
    }

}

extension AppService: MediaService {

    func mediaReaderSession(forURL url: URL) async -> MediaReaderSession? {
        try? await service.perform(HTTP.Request.get("api/media/reader/session/url/\(url.absoluteString.urlEncoded)")).single()
    }

}

extension AppService: SearchService {

    func search(request: SearchRequest, page: Int = 1) async throws -> PaginatedResult<SearchResult> {
        let parameters: [String: Any] = [
            "page": page,
            "per": 50,
            "q": request.query,
            "audiobook": false,
            "exact": false
        ]

        let endpoint: String
        switch request.type {
        case .words:
            endpoint = "dictionary/search"
        case .youtube:
            endpoint = "media/youtube/subtitles/search"
        case .other:
            endpoint = "media/anki/subtitles/search"
        }

        let httpRequest = HTTP.Request.get(endpoint).parameters(parameters)
        switch request.type {
        case .words:
            let result = try await service.perform(httpRequest).single() as PaginatedResult<SearchWordResult>
            return PaginatedResult(items: result.items, metadata: result.metadata)
        case .youtube:
            let result = try await service.perform(httpRequest).single() as PaginatedResult<SearchVideoResult>
            return PaginatedResult(items: result.items, metadata: result.metadata)
        case .other:
            let result = try await service.perform(httpRequest).single() as PaginatedResult<SearchOtherResult>
            return PaginatedResult(items: result.items, metadata: result.metadata)
        }
    }

}
