//
//  LoginService.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation
import Combine

// MARK: - Dependency
protocol HasLoginService {
    var loginService: LoginServiceType { get set }
}

// MARK: - Login Service Type
protocol LoginServiceType {
    func requestToken() -> AnyPublisher<AuthenticationResponse, Error>
    func createSession(with token: String) -> AnyPublisher<LoginSession, Error>
    func login(using: LoginCredential) ->  AnyPublisher<AuthenticationResponse, Error>
}

// MARK: - Service
struct LoginService: LoginServiceType {
    typealias Dependencies = HasNetworkManager
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func requestToken() -> AnyPublisher<AuthenticationResponse, Error> {
        dependencies
            .networkManager
            .execute(on: LoginServiceTarget.requestToken, decoder: .init())
            .eraseToAnyPublisher()
    }
    
    func createSession(with token: String) -> AnyPublisher<LoginSession, Error> {
        dependencies
            .networkManager
            .execute(on: LoginServiceTarget.newSession(request: .init(requestToken: token)), decoder: .init())
            .eraseToAnyPublisher()
    }
    
    func login(using credentials: LoginCredential) -> AnyPublisher<AuthenticationResponse, Error> {
        dependencies
            .networkManager
            .execute(on: LoginServiceTarget.login(credentials: credentials), decoder: .init())
            .eraseToAnyPublisher()
    }
}

// MARK: - Service Dependencies
struct LoginServiceDependencies: HasNetworkManager {
    var networkManager: NetworkManagerType = NetworkManager(requester: URLSession.shared)
}
