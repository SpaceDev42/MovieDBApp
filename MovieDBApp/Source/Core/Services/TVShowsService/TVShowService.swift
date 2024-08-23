//
//  TVShowService.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 15/3/24.
//

import Foundation
import Combine

// MARK: - Dependency
protocol HasTVShoswService {
    var loginService: LoginServiceType { get set }
}

// MARK: - Login Service Type
protocol TVShowsServiceType {
    func fetchTvShows(from target: TVShowsTarget) -> AnyPublisher<TVShowsData, Error>
}

// MARK: - Service
struct TVShowsService: TVShowsServiceType {
    typealias Dependencies = HasNetworkManager
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func fetchTvShows(from target: TVShowsTarget) -> AnyPublisher<TVShowsData, Error> {
        dependencies
            .networkManager
            .execute(on: target, decoder: .init())
            .eraseToAnyPublisher()
    }
}

// MARK: - Service Dependencies
struct TVShowsServiceDependencies: HasNetworkManager {
    var networkManager: NetworkManagerType = NetworkManager(requester: URLSession.shared)
}
