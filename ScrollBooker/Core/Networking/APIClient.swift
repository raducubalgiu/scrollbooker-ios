//
//  APIClient.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

actor APIClient {
    private let config: NetworkConfig
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
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
    
    func addInterceptor(_ interceptor: RequestInterceptor) {
        self.interceptors.append(interceptor)
    }
    
    func request<T: Decodable, B: Encodable>(
        _ path: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        query: [String: String]? = nil,
        body: B? = nil
    ) async throws -> T {
        return try await executeWithRetry(attempts: 0) { [unowned self] in
            var components = URLComponents(url: self.config.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
            if let query {
                components?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
            }
            guard let url = components?.url else { throw APIError.invalidURL }
            
            var req = URLRequest(url: url)
            req.httpMethod = method.rawValue
            
            self.config.defaultHeaders.merging(headers, uniquingKeysWith: { _, new in new })
                .forEach { req.setValue($1, forHTTPHeaderField: $0) }
            
            if let body {
                req.httpBody = try self.encoder.encode(body)
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
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
    
    func request<T: Decodable>(
            _ path: String,
            method: HTTPMethod = .get,
            headers: [String: String] = [:],
            query: [String: String]? = nil
        ) async throws -> T {
            // Apelăm funcția ta principală, dar fixăm tipul corpului (B) ca fiind structura 'Empty'
            // Acest lucru îi spune clar compilatorului că corpul este nil și îndeplinește criteriul Encodable
            try await request(
                path,
                method: method,
                headers: headers,
                query: query,
                body: Optional<Empty>.none
            )
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
            
            for interceptor in self.interceptors {
                req = try await interceptor.adapt(req)
            }
            
            let tempFileURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension("tmp")
            
            guard let stream = OutputStream(url: tempFileURL, append: false) else {
                throw APIError.server(status: 0, data: nil)
            }
            stream.open()
            defer { stream.close() }
            
            for (key, value) in fields {
                if let boundaryData = "--\(boundary)\r\n".data(using: .utf8) { try stream.writeData(boundaryData) }
                if let dispData = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8) { try stream.writeData(dispData) }
                if let valueData = "\(value)\r\n".data(using: .utf8) { try stream.writeData(valueData) }
            }
            
            for file in files {
                if let boundaryData = "--\(boundary)\r\n".data(using: .utf8) { try stream.writeData(boundaryData) }
                if let dispData = "Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.filename)\"\r\n".data(using: .utf8) { try stream.writeData(dispData) }
                if let typeData = "Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8) { try stream.writeData(typeData) }
                try stream.writeData(file.data)
                if let lineBreak = "\r\n".data(using: .utf8) { try stream.writeData(lineBreak) }
            }
            
            if let endBoundaryData = "--\(boundary)--\r\n".data(using: .utf8) {
                try stream.writeData(endBoundaryData)
            }
            
            NetworkLogger.request(req, body: "[Multipart Streaming From Disk]".data(using: .utf8))
            let (data, resp) = try await self.session.upload(for: req, fromFile: tempFileURL)
            
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
                
                let boundary = "Boundary-\(UUID().uuidString)"
                var allHeaders = self.config.defaultHeaders.merging(headers, uniquingKeysWith: { _, new in new })
                allHeaders["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
                
                for interceptor in self.interceptors {
                    req = try await interceptor.adapt(req)
                }
                allHeaders.forEach { req.setValue($1, forHTTPHeaderField: $0) }
                
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
    
    private func handleResponse<T: Decodable>(_ http: HTTPURLResponse, data: Data) throws -> T {
        guard (200...299).contains(http.statusCode) else {
            throw APIError.server(status: http.statusCode, data: data)
        }
        
        if T.self == NoContent.self {
            return NoContent() as! T
        }
        
        do {
            return try self.decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            print("------- 🚨 EROARE DE DECODARE DETALIATĂ 🚨 -------")
            switch error {
            case .typeMismatch(let type, let context):
                let path = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
                print("❌ TIP INCORECT: Se aștepta tipul '\(type)' la cheia: [ \(path) ]")
                print("💡 Detalii backend: \(context.debugDescription)")
                
            case .valueNotFound(let type, let context):
                let path = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
                print("❌ VALOARE NULL: Câmpul non-opțional '\(type)' a primit null în JSON la cheia: [ \(path) ]")
                
            case .keyNotFound(let key, let context):
                let path = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
                print("❌ CHEIE LIPSĂ: Serverul nu a trimis cheia '\(key.stringValue)' în structura: [ \(path) ]")
                
            case .dataCorrupted(let context):
                print("❌ JSON INVALID: Datele sunt corupte structural la nivel de text JSON: \(context.debugDescription)")
                
            @unknown default:
                print("❌ Eroare de decodare necunoscută: \(error)")
            }
            print("-------------------------------------------------")
            throw error
        } catch {
            print("⚠️ Alt tip de eroare apărut la procesarea datelor: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func executeWithRetry<T>(attempts: Int, action: @escaping () async throws -> T) async throws -> T {
        do {
            return try await action()
        } catch {
            for interceptor in interceptors {
                let dummyRequest = URLRequest(url: config.baseURL)
                if try await interceptor.retry(dummyRequest, dueTo: error, attempts: attempts + 1) {
                    return try await executeWithRetry(attempts: attempts + 1, action: action)
                }
            }
            throw error
        }
    }
}

private extension OutputStream {
    func writeString(_ string: String) throws {
        guard let data = string.data(using: .utf8) else { return }
        try writeData(data)
    }
    
    func writeData(_ data: Data) throws {
        data.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) in
            guard let baseAddress = buffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
            self.write(baseAddress, maxLength: data.count)
        }
    }
}


struct Empty: Codable {}

struct MultipartFile: Sendable {
    let name: String
    let filename: String
    let data: Data
    let mimeType: String
}

@propertyWrapper
struct LossyDecimal: Codable, Hashable, Sendable {
    var wrappedValue: Decimal
    
    init(wrappedValue: Decimal) {
        self.wrappedValue = wrappedValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 1. Încercăm să îl decodăm ca număr (Double) - PROTEJAT la pierderea de precizie
        if let numericValue = try? container.decode(Double.self) {
            // Conversia prin String ne asigură că prețul rămâne curat, de ex. "19.99" în loc de "19.990000002"
            self.wrappedValue = Decimal(string: String(numericValue)) ?? Decimal(numericValue)
            return
        }
        
        // 2. Încercăm ca String (Cazul FastAPI: "100.0")
        if let stringValue = try? container.decode(String.self),
           let decimalValue = Decimal(string: stringValue) {
            self.wrappedValue = decimalValue
            return
        }
        
        // 3. Fallback sigur
        self.wrappedValue = try container.decode(Decimal.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

@propertyWrapper
struct LossyOptionalDecimal: Codable, Hashable, Sendable {
    var wrappedValue: Decimal?
    
    init(wrappedValue: Decimal?) {
        self.wrappedValue = wrappedValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self.wrappedValue = nil
            return
        }
        
        if let numericValue = try? container.decode(Double.self) {
            // Aceeași optimizare pentru precizie și aici
            self.wrappedValue = Decimal(string: String(numericValue)) ?? Decimal(numericValue)
            return
        }
        
        if let stringValue = try? container.decode(String.self),
           let decimalValue = Decimal(string: stringValue) {
            self.wrappedValue = decimalValue
            return
        }
        
        self.wrappedValue = try? container.decode(Decimal.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = wrappedValue {
            try container.encode(value)
        } else {
            try container.encodeNil()
        }
    }
}
