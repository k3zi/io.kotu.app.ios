import Foundation

struct SearchRequest {

    var query: String
    var type: SearchType

}

struct PaginatedSearchRequest {

    let request: SearchRequest
    var page: Int = 1

}
