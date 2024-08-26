//
//  Dictionary+Codable.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 24/8/24.
//

import Foundation

// MARK: - Encode Dictionary
extension Encodable {
    func encodeAsDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        else { return nil }
        
        return dictionary
    }
}

// MARK: - Decode Dictionary
extension Decodable {
    func decodeDictionary(from dictionary: [String: Any]) -> Self? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self),
              let decodedObject = try? JSONDecoder().decode(Self.self, from: jsonData)
        else { return nil }
        
        return decodedObject
    }
}
