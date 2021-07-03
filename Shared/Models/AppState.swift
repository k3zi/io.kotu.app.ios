import Foundation

class AppState: ObservableObject {

    @Published var user: User

    init(user: User) {
        self.user = user
    }

}
