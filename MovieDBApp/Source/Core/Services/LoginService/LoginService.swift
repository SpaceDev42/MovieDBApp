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
// TODO: Remove methods implemented with Combine
protocol LoginServiceType {
    func requestToken() -> AnyPublisher<AuthenticationResponse, Error>
    func createSession(with token: String) -> AnyPublisher<LoginSession, Error>
    func login(using credentials: LoginCredential) ->  AnyPublisher<AuthenticationResponse, Error>
    
    func requestToken() async throws -> AuthenticationResponse
    func createSession(with token: String) async throws -> LoginSession
    func login(using credentials: LoginCredential) async throws ->  AuthenticationResponse
}

// MARK: - Service
// TODO: Remove methods implemented with Combine
struct LoginService: LoginServiceType {
    typealias Dependencies = HasNetworkManager
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Combine
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
    
    // MARK: - Async Await
    func requestToken() async throws -> AuthenticationResponse {
        try await dependencies.networkManager.execute(on: LoginServiceTarget.requestToken, decoder: .init())
    }
    
    func createSession(with token: String) async throws -> LoginSession {
        try await dependencies
            .networkManager
            .execute(on: LoginServiceTarget.newSession(request: .init(requestToken: token)), decoder: .init())
    }
    
    func login(using credentials: LoginCredential) async throws -> AuthenticationResponse {
        try await dependencies
            .networkManager
            .execute(on: LoginServiceTarget.login(credentials: credentials), decoder: .init())
    }
}

// MARK: - Service Dependencies
struct LoginServiceDependencies: HasNetworkManager {
    var networkManager: NetworkManagerType = NetworkManager(requester: URLSession.shared)
}
