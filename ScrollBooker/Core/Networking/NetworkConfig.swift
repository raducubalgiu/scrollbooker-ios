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
    
    init(baseURL: URL, defaultHeaders: [String : String] = ["Accept": "application/json"]) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
    }
}
