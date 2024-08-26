//
//  LoginServiceTarget.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation

enum LoginServiceTarget: MovieDBTargetType {
    case newSession(request: sessionRequest)
    case requestToken
    case login(credentials: LoginCredential)
}

extension LoginServiceTarget {
    var parameters: [String : Any]? {
        return AuthenticationParameters.default.encodeAsDictionary()
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
        case .newSession(let request):
            return try? JSONEncoder().encode(request)
        case .login(let credentials):
            return try? JSONEncoder().encode(credentials)
        }
    }
}
