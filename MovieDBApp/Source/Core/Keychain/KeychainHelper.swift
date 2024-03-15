//
//  KeychainHelper.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 14/3/24.
//

import Foundation

// MARK: - Dependency
protocol HasKeychainHelper {
    var keychainHelper: KeychainHelperType { get set }
}

//MARK: - KeychainManagerType Protocol
protocol KeychainHelperType{
    func getString(for serviceKey: String) -> String
    func setString(_ value: String, for servicekey: String) throws
    func clean(service: String)
}

// MARK: - Helper Errors
enum KeychainHelperError: Error, Equatable {
    case noItemFound
    case duplicateItem
    case unexpectedData
    case unhandledError(status: OSStatus)
}

// MARK: - Service Key
enum KeychainServiceKey: String {
    case sessionId
}

// MARK: - Helper
class KeychainHelper: KeychainHelperType {
    private let account: String = "TheMovieDB"
    
    static let shared = KeychainHelper()
    
    //MARK: - Initialization
    private init() {}
    
    func getString(for serviceKey: String) -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceKey,
            kSecAttrAccount: account,
            kSecReturnData: true
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let value = dataTypeRef as? String else { return "" }
        
        return value
    }

    func setString(_ value: String, for serviceKey: String) throws {
        guard let data = value.data(using: .utf8) else { throw KeychainHelperError.unexpectedData }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceKey,
            kSecAttrAccount: account,
            kSecValueData:  data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainHelperError.unhandledError(status: status)
        }
    }

    func clean(service: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
