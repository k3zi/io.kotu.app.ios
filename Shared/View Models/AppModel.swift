import Foundation

@MainActor
class AppModel: ObservableObject {

    @Published var user: User?

    init() {

    }

}
