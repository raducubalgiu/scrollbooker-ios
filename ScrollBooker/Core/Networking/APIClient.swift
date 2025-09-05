//
//  APIClient.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import Foundation

struct MultipartFile {
    let name: String
    let filename: String
    let data: Data
    let mimeType: String
}

final class APIClient {
    private let config: NetworkConfig
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(config: NetworkConfig,
         session: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()
    ) {
        self.config = config
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    // MARK: Request cu body (generic)
    func request<T: Decodable, B: Encodable>(
        _ path: String,
        method: HTTPMethod = .get,
        headers: [String:String] = [:],
        bearer: String? = nil,
        query: [String:String]? = nil,
        body: B? = nil
    ) async throws -> T {
        var components = URLComponents(
            url: config.baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )
        if let query {
            components?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = components?.url else { throw APIError.invalidURL }
        

        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        
        // headers
        (config.defaultHeaders.merging(headers, uniquingKeysWith: { _, new in new } ))
            .forEach { req.setValue($1, forHTTPHeaderField: $0) }
        
        if let bearer, !bearer.isEmpty {
            req.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
        }
        
        if let body {
            req.httpBody = try encoder.encode(body)
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Log Request
        NetworkLogger.request(req, body: req.httpBody)
        
        let (data, resp) = try await session.data(for: req)
        
        guard let http = resp as? HTTPURLResponse else { throw APIError.invalidResponse }
        
        // Log Response
        NetworkLogger.response(http, data: data)
        
        switch http.statusCode {
            case 200..<300:
                if T.self  == Empty.self { return Empty() as! T }
                do { return try decoder.decode(T.self, from: data) }
                catch { throw APIError.decoding(error) }
            case 401: throw APIError.unauthorized
            case 404: throw APIError.notFound
            default: throw APIError.server(status: http.statusCode, data: data)
        }
    }
    
    // MARK: - Overload fara body
    func request<T: Decodable>(
        _ path: String,
        method: HTTPMethod = .get,
        headers: [String:String] = [:],
        bearer: String? = nil,
        query: [String:String]? = nil
    ) async throws -> T {
        try await request(
            path,
            method: method,
            headers: headers,
            bearer: bearer,
            query: query,
            body: Optional<Empty>.none
        )
    }
    
    func multiPartRequest<T: Decodable>(
        _ path: String,
        method: HTTPMethod = .post,
        headers: [String: String] = [:],
        bearer: String? = nil,
        fields: [String: String],
        files: [MultipartFile] = []
    ) async throws -> T {
        var url = config.baseURL
        url.appendPathComponent(path)
        
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var allHeaders = config.defaultHeaders.merging(headers, uniquingKeysWith: { _, new in new })
        allHeaders["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        if let bearer { allHeaders["Authorization"] = "Bearer \(bearer)" }
        allHeaders.forEach { req.setValue($1, forHTTPHeaderField: $0) }
        
        var body = Data()
        
        for (key, value) in fields {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        for file in files {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.filename)\"\r\n")
            body.append("Content-Type: \(file.mimeType)\r\n\r\n")
            body.append(file.data)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        req.httpBody = body
        
        let (data, resp) = try await session.data(for: req)
        
//        #if DEBUG
//        if let http = resp as? HTTPURLResponse {
//            print("[\(http.statusCode)] \(req.url?.absoluteString ?? "")")
//            if let raw = String(data: data, encoding: .utf8) {
//                print("Response body: \n\(raw)")
//            } else {
//                print("Response body: <binary \(data.count) bytes>")
//            }
//        }
//        #endif
        
        guard let http = resp as? HTTPURLResponse else { throw APIError.invalidResponse }
        
        switch http.statusCode {
            case 200..<300:
                if T.self  == Empty.self { return Empty() as! T }
                do { return try decoder.decode(T.self, from: data) }
                catch { throw APIError.decoding(error) }
            case 401: throw APIError.unauthorized
            case 404: throw APIError.notFound
            default: throw APIError.server(status: http.statusCode, data: data)
        }
    }
}

private extension Data {
    mutating func append(_ string: String) {
        self.append(string.data(using: .utf8)!)
    }
}

struct Empty: Codable {}
