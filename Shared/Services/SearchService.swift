import Foundation

protocol SearchService {

    func search(request: SearchRequest, page: Int) async throws -> PaginatedResult<SearchResult>

}

extension SearchService {

    func search(request: SearchRequest) async throws -> PaginatedResult<SearchResult> {
        try await search(request: request, page: 1)
    }

}
