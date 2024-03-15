//
//  LoginCredentials.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation

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

struct TokenCrediential: Codable {
    var requestToken: String?
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
}

struct LoginSessionCrediential: Codable {
    var sessionId: String

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
    }
}
