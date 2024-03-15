//
//  MovieDBTarget.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation

//MARK: - Http methods
enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

//MARK: - Request protocol
protocol MovieDBTargetType {
    var host: String { get }
    var path: String { get }
    var body: Data? { get }
    var parameters: [String: Any]? { get }
    var method: RequestMethod { get }
    var url: URL? { get }
}

extension MovieDBTargetType {
    var host: String {
        "api.themoviedb.org"
    }

    var body: Data? {
        nil
    }
    
    var url: URL? {
        var components = URLComponents()

        components.scheme = "https"
        components.host = host
        components.path = path

        if let params = parameters {
            components.queryItems = params.map{ URLQueryItem(name: $0.key, value: $0.value as? String) }
        }

        return components.url
    }
}
