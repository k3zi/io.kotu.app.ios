import Foundation
import SwiftUI

@MainActor
class LoginModel: ObservableObject {

    enum Error: Swift.Error, LocalizedError {
        case noUsernameProvided
        case noPasswordProvided

        var errorDescription: String? {
            switch self {
            case .noUsernameProvided: return "No username provided."
            case .noPasswordProvided: return "No password provided."
            }
        }
    }

    @Published var username = ""
    @Published var password = ""
    @Published var error: Error?
    @Published var showError = false
    @Published var isInitialLoad = true
    @Published var isLoading = true

    @Binding var user: User?

    private let service: LoginService

    init(service: LoginService, user: Binding<User?>) {
        self.service = service
        self._user = user
    }

    private func internalSubmit() async throws {
        user = try await service.login(withUsername: username, password: password)
    }

    func checkIfLoggedIn() async {
        isLoading = true
        try? await internalSubmit()
        isLoading = false
        isInitialLoad = false
    }

    func submit() async {
        isLoading = true
        do {
            try await internalSubmit()
        } catch {
            self.error = error as? Error
            self.showError = true
        }
        isLoading = false
    }

}
