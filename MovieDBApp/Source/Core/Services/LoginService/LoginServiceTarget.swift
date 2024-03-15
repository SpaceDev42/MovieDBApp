//
//  LoginServiceTarget.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation

enum LoginServiceTarget: MovieDBTargetType {
    case newSession(token: String)
    case requestToken
    case login(credentials: LoginCredential)
}

extension LoginServiceTarget {
    var parameters: [String : Any]? {
        ["api_key": Constant.apiKey]
    }
    
    var path: String {
        switch self {
        case .newSession:
            return "/3/authentication/session/new"
        case .requestToken:
            return "/3/authentication/token/new"
        case .login:
            return "/3/authentication/token/validate_with_login"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .newSession, .login:
            return .post
        case .requestToken:
            return .get
        }
    }
    
    var body: Data? {
        switch self {
        case .requestToken:
            return nil
        case .newSession(let token):
            let tokenCredential = TokenCrediential(requestToken: token)

            return try? JSONEncoder().encode(tokenCredential)
        case .login(let credentials):
            return try? JSONEncoder().encode(credentials)
        }
    }
}
