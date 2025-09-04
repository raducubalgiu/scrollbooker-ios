//
//  APIError.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case notFound
    case server(status: Int, data: Data?)
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid Response"
        case .unauthorized: return "Unathorized"
        case .notFound: return "Not Found"
        case .server(let s, _): return "Server Error \(s)"
        case .decoding(let e): return "Decoding Error: \(e.localizedDescription)"
        }
    }
}
