import Foundation

struct PaginatedResultMetadata: Decodable {
    let page: Int
    let per: Int
    let total: Int
}

struct PaginatedResult<T> {

    let items: [T]
    let metadata: PaginatedResultMetadata

    var canLoadNextPage: Bool {
        metadata.page * metadata.per < metadata.total
    }

}

extension PaginatedResult: Decodable where T: Decodable {

}
