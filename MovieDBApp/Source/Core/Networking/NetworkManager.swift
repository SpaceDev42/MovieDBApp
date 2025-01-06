//
//  NetworkManager.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation
import Combine

// MARK: - Remove methods that are using Combine
// MARK: -  Network Manager Dependency
protocol HasNetworkManager {
    var networkManager: NetworkManagerType { get set }
}

// MARK: - Network Manager Protocols
protocol NetworkManagerType {
    func execute<T: Codable>(on target: MovieDBTargetType, decoder: JSONDecoder) -> AnyPublisher<T, Error>
    func execute<T: Codable>(on target: MovieDBTargetType, decoder: JSONDecoder) async throws -> T
}

// MARK: - Network Requester Protocols
protocol NetworkRequesterType {
    func requestData<T: Codable>(for target: MovieDBTargetType,with decoder: JSONDecoder) -> AnyPublisher<T, Error>
    func requestData<T: Codable>(for target: MovieDBTargetType,with decoder: JSONDecoder) async throws -> T
}


// MARK: - Network Service
class NetworkManager: NetworkManagerType {
    private let requester: NetworkRequesterType
    
    init(requester: NetworkRequesterType = URLSession.shared) {
        self.requester = requester
    }
    
    // MARK: - Execute Network Request
    /// This method execute a network request using Combine
    func execute<T: Codable>(
        on target: MovieDBTargetType,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<T, Error> {
        requester.requestData(for: target, with: decoder)
    }
    
    /// This method execute a network request using Swift Concurrency
    func execute<T: Codable>(
        on target: any MovieDBTargetType,
        decoder: JSONDecoder = .init()
    ) async throws -> T  {
        try await requester.requestData(for: target, with: decoder)
    }
}

// MARK: - URLSession Extension
extension URLSession: NetworkRequesterType {
    private func buildURLRequest(for target: MovieDBTargetType) -> URLRequest? {
        guard let url = target.url else { return nil }
        
        var request = URLRequest(url: url)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + Constant.accessToken, forHTTPHeaderField: "Authorization")

        request.httpMethod = target.method.rawValue
        request.httpBody = target.body
        
        return request
    }
    
    /// This method request using Combine
    func requestData<T: Decodable>(
        for target: MovieDBTargetType,
        with decoder: JSONDecoder
    ) -> AnyPublisher<T, Error> {
        guard let request = buildURLRequest(for: target) else {
            return Empty().eraseToAnyPublisher()
        }
        
        // MARK: - Combine Implementation
        return dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode)
                else {
                    return data
                }
                
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    /// This method request using Swift Concurrency
    func requestData<T: Codable>(
        for target: MovieDBTargetType,
        with decoder: JSONDecoder
    ) async throws -> T {
        guard let request = buildURLRequest(for: target) else {
            throw NetworkError.failedRequest
        }
        
        let (data, response) = try await data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else {
            throw NetworkError.invalidResponse
        }
        
        return try decoder.decode(T.self, from: data)
    }
}

