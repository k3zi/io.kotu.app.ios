import Foundation

struct SearchOtherResult: Decodable, SearchResult {

    struct Video: Decodable {
        let id: UUID
        let title: String
        let source: String
        let tags: [String]
    }

    let id: UUID
    let externalFile: ExternalFile
    let text: String
    let video: Video

    var stringID: String {
        id.uuidString
    }

}
