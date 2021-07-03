import Foundation

protocol DictionaryService {

    func dictionaryIcon(forID id: UUID) -> URL
    func dictionaryURL(for searchResult: SearchWordResult) -> URL?

}
