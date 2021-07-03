import Foundation

struct SearchWordResult: Decodable, SearchResult {

    struct Dictionary: Decodable {
        let id: UUID
    }

    struct Entry: Decodable {
        let id: UUID
    }

    let dictionary: Dictionary
    let entry: Entry?

    let headline: String
    let shortHeadline: String
    let entryIndex: Int
    let subentryIndex: Int

    var stringID: String {
        "\(dictionary.id)-\(entryIndex)-\(subentryIndex)"
    }

    var tags: [String] {
        [
            subentryIndex > 0 ? "Subentry" : nil
        ]
        .compactMap { $0 }
        .filter { !$0.isEmpty }
    }

}
