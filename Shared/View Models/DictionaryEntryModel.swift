import Foundation

@MainActor
class DictionaryEntryModel: ObservableObject {

    enum Headword {
        case searchWordResult(SearchWordResult)
    }

    private let service: DictionaryService
    private let headword: Headword

    var url: URL {
        switch headword {
        case .searchWordResult(let result):
           return service.dictionaryURL(for: result)!
        }
    }

    init(service: DictionaryService, headword: Headword) {
        self.service = service
        self.headword = headword
    }

}
