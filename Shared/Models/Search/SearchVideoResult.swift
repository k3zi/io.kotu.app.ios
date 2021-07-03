import Foundation

struct SearchVideoResult: Decodable, SearchResult {

    enum CodingKeys: String, CodingKey {
        case id, text
        case video = "youtubeVideo"
    }

    struct Video: Decodable {
        let id: UUID
        let title: String
        let thumbnailURL: URL
    }

    let id: UUID
    let text: String
    let video: Video

    var stringID: String {
        id.uuidString
    }

}
