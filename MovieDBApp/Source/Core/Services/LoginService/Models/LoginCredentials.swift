//
//  LoginCredentials.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation

// MARK: - Login Credentials
struct LoginCredential: Codable {
    let username: String
    let password: String
    let requestToken: String

    enum CodingKeys: String, CodingKey {
        case username
        case password
        case requestToken = "request_token"
    }
}

// MARK: - Token Parameters
struct AuthenticationParameters: Codable {
    let apiKey: String
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
    
    // MARK: - Default Parameters
    static var `default`: AuthenticationParameters {
        .init(apiKey: "8449684129a2a529702587d8512f6a2d")
    }
}

// MARK: - Token Credential
struct AuthenticationResponse: Codable {
    let success: Bool
    let expirationDate: String
    let requestToken: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case expirationDate = "expires_at"
        case requestToken = "request_token"
    }
}

// MARK: - Login Session Credential
struct LoginSessionCrediential: Codable {
    var sessionId: String

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
    }
}
