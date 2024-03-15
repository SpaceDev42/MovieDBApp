//
//  LoginSession.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation

struct LoginSession: Codable {
    var success: Bool
    var sessionId: String?
    var statusCode: Int?
    var statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}
