//
//  NetworkConfig.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

/// Structură responsabilă de configurarea globală a rețelei.
struct NetworkConfig {
    let baseURL: URL
    let defaultHeaders: [String: String]

    init(baseURL: URL, defaultHeaders: [String: String] = ["Accept": "application/json"]) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
    }

    /// Sursă unică de adevăr pentru configurarea rețelei la nivel enterprise.
    static var `default`: NetworkConfig {
        guard let rawHost = Bundle.main.object(forInfoDictionaryKey: "API_HOST") as? String else {
            fatalError("CRITICAL: 'API_HOST' is missing in Target Info settings!")
        }

        let host = rawHost.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !host.isEmpty else {
            fatalError("CRITICAL: 'API_HOST' is empty in Target Info settings! Please check your active .xcconfig file.")
        }

        let rawScheme = Bundle.main.object(forInfoDictionaryKey: "API_SCHEME") as? String
        let scheme = rawScheme?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "https"

        // SOLUȚIE ENTERPRISE: Construim string-ul URL complet înainte de a-l transforma în obiect URL,
        // garantând că path-ul "/api/v1" nu va fi eliminat sau deformat de mecanismele interne URLComponents.
        let fullURLString = "\(scheme)://\(host)/api/v1"
        
        guard let url = URL(string: fullURLString) else {
            fatalError("CRITICAL: Failed to build a valid URL from base string: '\(fullURLString)'!")
        }

        return NetworkConfig(baseURL: url)
    }
}

