//
//  NetworkError.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case failedRequest
    case addressUnreachable
    case invalidResponse

    var localizedDescription: String? {
        switch self {
        case .failedRequest:
            return  "Sorry something went wrong, please try again."
        case .invalidResponse:
            return "Sorry the connection with our server failed."
        case .addressUnreachable:
            return "Sorry something went wrong"
        }
    }
}
