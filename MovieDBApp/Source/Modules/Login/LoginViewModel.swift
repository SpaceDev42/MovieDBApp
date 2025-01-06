//
//  LoginViewModel.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    // Typealias
    typealias Dependencies = HasLoginService & HasKeychainHelper
    
    // MARK: - Published Properties
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLogging: Bool = false
    @Published var showingAlert: Bool = false

    // MARK: - Properties
    private let dependencies: Dependencies
    private let coordinator: MainCoordinatorType?
    private var cancellables: Set<AnyCancellable> = []
    var loginSubject: PassthroughSubject<Void, Never> = .init()
    
    var loginDisabled: Bool {
        let usernameIsCorrect = !username.contains(" ") && !username.isEmpty
        let passwordIsCorrect = !password.contains(" ") && !password.isEmpty

        return !(usernameIsCorrect && passwordIsCorrect)
    }

    // MARK: - Initialization
    init(dependencies: Dependencies, coordinator: CoordinatorType) {
        self.dependencies = dependencies
        self.coordinator = coordinator as? MainCoordinator
    }
    
    // MARK: - Reset Credentials
    func resetCredentials() {
        username = ""
        password = ""
    }

    // MARK: - Login
    func login() {
        isLogging = true
        
        Task {
            do {
                try await validateCredentials()
            } catch {
                isLogging = false
                showingAlert = true
            }
        }
    }
    
    // MARK: - Validate Credentials
    private func validateCredentials() async throws {
        let loginService = dependencies.loginService

        guard let requestToken = try await loginService.requestToken().requestToken else {
            throw NetworkError.invalidResponse
        }
        
        let credentials = LoginCredential(username: username, password: password, requestToken: requestToken)
        
        guard let validatedToken = try await loginService.login(using: credentials).requestToken else {
            throw NetworkError.invalidResponse
        }

        let sessionResponse = try await loginService.createSession(with: validatedToken)
        await handleSessionResponse(sessionResponse)
    }

    // MARK: - Handle Session Response
    @MainActor
    private func handleSessionResponse(_ response: LoginSession) {
        guard let sessionId = response.sessionId else { return }

        isLogging = false
        coordinator?.presentTVshows()
        try? dependencies.keychainHelper.setString(sessionId, for: KeychainServiceKey.sessionId.rawValue)
    }
}

// MARK: - ViewModel Dependencies
struct LoginViewModelDependencies: HasLoginService & HasKeychainHelper {
    var keychainHelper: KeychainHelperType = KeychainHelper.shared
    var loginService: LoginServiceType = LoginService(dependencies: LoginServiceDependencies())
}
