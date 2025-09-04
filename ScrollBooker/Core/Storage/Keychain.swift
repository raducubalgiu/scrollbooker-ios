//
//  Keychain.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation
import Security

enum KeychainError: Error { case unexpectedStatus(OSStatus) }

struct Keychain {
    static func set(_ value: String?, key: String, service: String) throws {
        let q: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        if let value {
            let data = Data(value.utf8)
            let status = SecItemUpdate(q as CFDictionary, [kSecValueData as String: data] as CFDictionary)
            if status == errSecItemNotFound {
                var add = q; add[kSecValueData as String] = data
                let s = SecItemAdd(add as CFDictionary, nil)
                guard s == errSecSuccess else { throw KeychainError.unexpectedStatus(s) }
            } else if status != errSecSuccess {
                throw KeychainError.unexpectedStatus(status)
            }
        } else {
            SecItemDelete(q as CFDictionary)  // ignore status
        }
    }
    
    static func get(_ key: String, service: String) throws -> String? {
        let q: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let s = SecItemCopyMatching(q as CFDictionary, &item)
        if s == errSecItemNotFound { return nil }
        guard s == errSecSuccess, let data = item as? Data else { throw KeychainError.unexpectedStatus(s) }
        
        return String(data: data, encoding: .utf8)
    }
}
