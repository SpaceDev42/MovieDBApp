//
//  NetworkManager.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation
import Combine

// MARK: -  Network Manager Dependency
protocol HasNetworkManager {
    var networkManager: NetworkManagerType { get set }
}

// MARK: - Network Manager Protocols
protocol NetworkManagerType {
    func execute<T: Decodable>(on target: MovieDBTargetType,
                               decoder: JSONDecoder) -> AnyPublisher<T, Error>
}

// MARK: - Network Requester Protocols
protocol NetworkRequesterType {
    func requestData<T: Decodable>(
        for target: MovieDBTargetType,
        with decoder: JSONDecoder
    ) -> AnyPublisher<T, Error>
}


// MARK: - Network Service
class NetworkManager: NetworkManagerType {
    private let requester: NetworkRequesterType
    
    init(requester: NetworkRequesterType = URLSession.shared) {
        self.requester = requester
    }
    
    func execute<T: Decodable>(
        on target: MovieDBTargetType,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        return requester.requestData(for: target, with: decoder)
    }
}

// MARK: - URLSession Extension
extension URLSession: NetworkRequesterType {
    func buildURLRequest(for target: MovieDBTargetType) -> URLRequest? {
        guard let url = target.url else { return nil }
        
        var request = URLRequest(url: url)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = .returnCacheDataElseLoad
        URLCache.shared.memoryCapacity = 536 * 1024 * 1024

        request.httpMethod = target.method.rawValue
        request.httpBody = target.body
        
        return request
    }
    
    func requestData<T: Decodable>(
        for target: MovieDBTargetType,
        with decoder: JSONDecoder
    ) -> AnyPublisher<T, Error> {
        guard let request = buildURLRequest(for: target) else {
            return Empty().eraseToAnyPublisher()
        }
        
        return dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode)
                else {
                    throw NetworkError.failedRequest
                }
                
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

