import Foundation

enum SearchType: CaseIterable {

    case words
    case youtube
    case other

    var displayValue: String {
        switch self {
        case .words: return "Words"
        case .youtube: return "Videos"
        case .other: return "Other"
        }
    }

}
