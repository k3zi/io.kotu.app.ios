import Foundation

protocol LoginService {

    func login(withUsername username: String, password: String) async throws -> User

}
