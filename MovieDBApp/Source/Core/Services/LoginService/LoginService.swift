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
    func fetchTokenResponse() -> AnyPublisher<TokenCrediential, Error>
    func createSession(with token: String) -> AnyPublisher<LoginSession, Error>
    func login(using: LoginCredential) ->  AnyPublisher<TokenCrediential, Error>
}

// MARK: - Service
struct LoginService: LoginServiceType {
    typealias Dependencies = HasNetworkManager
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func fetchTokenResponse() -> AnyPublisher<TokenCrediential, Error> {
        <#code#>
    }
    
    func createSession(with token: String) -> AnyPublisher<LoginSession, Error> {
        <#code#>
    }
    
    func login(using: LoginCredential) -> AnyPublisher<TokenCrediential, Error> {
        <#code#>
    }
}

// MARK: - Service Dependencies
struct LoginServiceDependencies: HasNetworkManager {
    var networkManager: NetworkManagerType = NetworkManager(requester: URLSession.shared)
}
