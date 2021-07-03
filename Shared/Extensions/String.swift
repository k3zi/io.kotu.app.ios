import Foundation

fileprivate let allowedQuerySet: CharacterSet = {
    var s = CharacterSet.urlQueryAllowed
    s.remove(charactersIn: ";/?:@&=+$, ")
    return s
}()

extension String {

    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: allowedQuerySet)!
    }

}
