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
    
    static var `default`: NetworkConfig {
        NetworkConfig(
            //baseURL: URL(string: "http://192.168.1.141:8000/api/v1")!,
            baseURL: URL(string: "http://localhost:8000/api/v1")!,
        )
    }
}
