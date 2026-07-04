//
//  NetworkConfig.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

struct NetworkConfig {
    let baseURL: URL
    let defaultHeaders: [String: String]

    init(baseURL: URL, defaultHeaders: [String: String] = ["Accept": "application/json"]) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
    }

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

        let fullURLString = "\(scheme)://\(host)/api/v1"
        
        guard let url = URL(string: fullURLString) else {
            fatalError("CRITICAL: Failed to build a valid URL from base string: '\(fullURLString)'!")
        }

        return NetworkConfig(baseURL: url)
    }
}

