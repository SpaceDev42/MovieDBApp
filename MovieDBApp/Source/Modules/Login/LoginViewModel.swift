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
    
    // MARK: - Authentication
    func validateUserCredentials() {
        isLogging = true
        
        dependencies
            .loginService
            .requestToken()
            .flatMap { [weak self] tokenResponse in
                guard let self = self,
                      let token = tokenResponse.requestToken
                else {
                    return Fail<AuthenticationResponse, Error>(error: NetworkError.invalidResponse)
                        .eraseToAnyPublisher()
                }
                
                let credentials = LoginCredential(
                    username: self.username,
                    password: self.password,
                    requestToken: token
                )
                
                return self.dependencies
                    .loginService
                    .login(using: credentials)
                    .eraseToAnyPublisher()
            }
            .flatMap { [weak self] tokenResponse  in
                guard let self = self,
                      let token = tokenResponse.requestToken
                else {
                    return Fail<LoginSession, Error>(error: NetworkError.invalidResponse)
                        .eraseToAnyPublisher()
                }
                
                return self.dependencies
                    .loginService
                    .createSession(with: token)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else { return }
                self?.isLogging = false
                self?.showingAlert = true
            } receiveValue: { [weak self] sessionResponse in
                guard let self = self, let sessionId = sessionResponse.sessionId else { return }

                
                self.isLogging = false
                try? self.dependencies.keychainHelper.setString(sessionId, for: KeychainServiceKey.sessionId.rawValue)
                self.coordinator?.presentTVshows()
            }
            .store(in: &cancellables)
    }
}

// MARK: - ViewModel Dependencies
struct LoginViewModelDependencies: HasLoginService & HasKeychainHelper {
    var keychainHelper: KeychainHelperType = KeychainHelper.shared
    var loginService: LoginServiceType = LoginService(dependencies: LoginServiceDependencies())
}
