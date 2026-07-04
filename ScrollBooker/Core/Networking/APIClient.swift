//
//  APIClient.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

/// Actor care garantează siguranța concurenței la nivel de thread-uri (Swift 6 strict compliance).
actor APIClient {
    private let config: NetworkConfig
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    // Lista de interceptori ce vor procesa secvențial fiecare cerere.
    private var interceptors: [RequestInterceptor] = []
    
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
    
    /// Permite înregistrarea dinamică a interceptorilor (ex: după ce AppContainer a fost inițializat).
    func addInterceptor(_ interceptor: RequestInterceptor) {
        self.interceptors.append(interceptor)
    }
    
    // MARK: - Core Request Engine
    func request<T: Decodable, B: Encodable>(
        _ path: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        query: [String: String]? = nil,
        body: B? = nil
    ) async throws -> T {
        return try await executeWithRetry(attempts: 0) { [unowned self] in
            // 1. Construcție URL inițial
            var components = URLComponents(url: self.config.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
            if let query {
                components?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
            }
            guard let url = components?.url else { throw APIError.invalidURL }
            
            var req = URLRequest(url: url)
            req.httpMethod = method.rawValue
            
            // 2. Aplicare Headers implicite
            self.config.defaultHeaders.merging(headers, uniquingKeysWith: { _, new in new })
                .forEach { req.setValue($1, forHTTPHeaderField: $0) }
            
            if let body {
                req.httpBody = try self.encoder.encode(body)
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            // 3. Rularea cererii prin faza de Adaptare a Interceptorilor
            for interceptor in self.interceptors {
                req = try await interceptor.adapt(req)
            }
            
            NetworkLogger.request(req, body: req.httpBody)
            
            let (data, resp) = try await self.session.data(for: req)
            guard let http = resp as? HTTPURLResponse else { throw APIError.invalidResponse }
            
            NetworkLogger.response(req, resp: http, data: data)
            return try self.handleResponse(http, data: data)
        }
    }
    
    // Overload convenabil fără corpul cererii (Body)
    func request<T: Decodable>(
        _ path: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        query: [String: String]? = nil
    ) async throws -> T {
        try await request(path, method: method, headers: headers, query: query, body: Optional<Empty>.none)
    }
    
    func multiPartRequest<T: Decodable>(
        _ path: String,
        method: HTTPMethod = .post,
        headers: [String: String] = [:],
        fields: [String: String],
        files: [MultipartFile] = []
    ) async throws -> T {
        return try await executeWithRetry(attempts: 0) { [unowned self] in
            let url = self.config.baseURL.appendingPathComponent(path)
            var req = URLRequest(url: url)
            req.httpMethod = method.rawValue
            
            let boundary = "Boundary-\(UUID().uuidString)"
            var allHeaders = self.config.defaultHeaders.merging(headers, uniquingKeysWith: { _, new in new })
            allHeaders["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
            allHeaders.forEach { req.setValue($1, forHTTPHeaderField: $0) }
            
            // Aplicare interceptori
            for interceptor in self.interceptors {
                req = try await interceptor.adapt(req)
            }
            
            // Locația fișierului temporar pe disc
            let tempFileURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension("tmp")
            
            guard let stream = OutputStream(url: tempFileURL, append: false) else {
                throw APIError.server(status: 0, data: nil)
            }
            stream.open()
            defer { stream.close() }
            
            // Scriem câmpurile text
            for (key, value) in fields {
                if let boundaryData = "--\(boundary)\r\n".data(using: .utf8) { try stream.writeData(boundaryData) }
                if let dispData = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8) { try stream.writeData(dispData) }
                if let valueData = "\(value)\r\n".data(using: .utf8) { try stream.writeData(valueData) }
            }
            
            // Scriem fișierele binare direct din sursă
            for file in files {
                if let boundaryData = "--\(boundary)\r\n".data(using: .utf8) { try stream.writeData(boundaryData) }
                if let dispData = "Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.filename)\"\r\n".data(using: .utf8) { try stream.writeData(dispData) }
                if let typeData = "Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8) { try stream.writeData(typeData) }
                try stream.writeData(file.data)
                if let lineBreak = "\r\n".data(using: .utf8) { try stream.writeData(lineBreak) }
            }
            
            // Scriem închiderea corpului multipart
            if let endBoundaryData = "--\(boundary)--\r\n".data(using: .utf8) {
                try stream.writeData(endBoundaryData)
            }
            
            // Executăm upload-ul folosind fișierul temporar creat pe disc
            NetworkLogger.request(req, body: "[Multipart Streaming From Disk]".data(using: .utf8))
            let (data, resp) = try await self.session.upload(for: req, fromFile: tempFileURL)
            
            // Ștergem fișierul temporar imediat după upload pentru a elibera spațiul
            try? FileManager.default.removeItem(at: tempFileURL)
            
            guard let http = resp as? HTTPURLResponse else { throw APIError.invalidResponse }
            NetworkLogger.response(req, resp: http, data: data)
            
            return try self.handleResponse(http, data: data)
        }
    }
    
    func formUrlEncodedRequest<T: Decodable>(
            _ path: String,
            method: HTTPMethod = .post,
            headers: [String: String] = [:],
            fields: [String: String]
        ) async throws -> T {
            return try await executeWithRetry(attempts: 0) { [unowned self] in
                let url = self.config.baseURL.appendingPathComponent(path)
                var req = URLRequest(url: url)
                req.httpMethod = method.rawValue
                
                // Reconstituim exact comportamentul tău inițial de generare binară
                let boundary = "Boundary-\(UUID().uuidString)"
                var allHeaders = self.config.defaultHeaders.merging(headers, uniquingKeysWith: { _, new in new })
                allHeaders["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
                
                for interceptor in self.interceptors {
                    req = try await interceptor.adapt(req)
                }
                allHeaders.forEach { req.setValue($1, forHTTPHeaderField: $0) }
                
                // Aici este EXACT logica ta originală de append direct în RAM care a mers!
                var body = Data()
                for (key, value) in fields {
                    if let boundaryData = "--\(boundary)\r\n".data(using: .utf8) { body.append(boundaryData) }
                    if let dispData = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8) { body.append(dispData) }
                    if let valueData = "\(value)\r\n".data(using: .utf8) { body.append(valueData) }
                }
                if let endBoundaryData = "--\(boundary)--\r\n".data(using: .utf8) { body.append(endBoundaryData) }
                
                req.httpBody = body
                
                NetworkLogger.request(req, body: body)
                let (data, resp) = try await self.session.data(for: req)
                
                guard let http = resp as? HTTPURLResponse else { throw APIError.invalidResponse }
                NetworkLogger.response(req, resp: http, data: data)
                
                return try self.handleResponse(http, data: data)
            }
        }
    
    // MARK: - Private Helpers
    private func handleResponse<T: Decodable>(_ http: HTTPURLResponse, data: Data) throws -> T {
        switch http.statusCode {
        case 200..<300:
            if T.self == Empty.self { return Empty() as! T }
            do { return try decoder.decode(T.self, from: data) }
            catch { throw APIError.decoding(error) }
        case 401: throw APIError.unauthorized
        case 404: throw APIError.notFound
        default: throw APIError.server(status: http.statusCode, data: data)
        }
    }
    
    /// Wrapper recursiv pentru managementul mecanic al funcției de Retry din interceptori
    private func executeWithRetry<T>(attempts: Int, action: @escaping () async throws -> T) async throws -> T {
        do {
            return try await action()
        } catch {
            // Iterăm prin interceptori să vedem dacă vreunul dorește să facă retry (ex: AuthInterceptor la 401)
            for interceptor in interceptors {
                // Generăm un URLRequest generic pentru testarea condiției de retry
                let dummyRequest = URLRequest(url: config.baseURL)
                if try await interceptor.retry(dummyRequest, dueTo: error, attempts: attempts + 1) {
                    return try await executeWithRetry(attempts: attempts + 1, action: action)
                }
            }
            throw error
        }
    }
}

// Extensie securizată pentru OutputStream, eliminând complet Force Unwrap-ul (`!`)
private extension OutputStream {
    func writeString(_ string: String) throws {
        guard let data = string.data(using: .utf8) else { return }
        try writeData(data)
    }
    
    func writeData(_ data: Data) throws {
        data.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) in
            guard let baseAddress = buffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
            // Am eliminat "_ =" de aici, apelând direct funcția nativă write
            self.write(baseAddress, maxLength: data.count)
        }
    }
}


struct Empty: Codable {}

/// Structură care definește un fișier binar pentru încărcările de tip Multipart (imagini, video)
struct MultipartFile: Sendable {
    let name: String
    let filename: String
    let data: Data
    let mimeType: String
}
