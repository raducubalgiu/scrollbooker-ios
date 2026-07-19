//
//  NetworkLogger.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation
import os

enum NetworkLogger {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.app.network", category: "Network")

    static func request(_ req: URLRequest, body: Data?) {
        #if DEBUG
        let method = req.httpMethod ?? "GET"
        let urlStr = req.url?.absoluteString ?? ""
        
        var headers = req.allHTTPHeaderFields ?? [:]
        if headers["Authorization"] != nil {
            headers["Authorization"] = "Bearer [REDACTED/PROTECTED]"
        }
        
        var bodyString = "nil"
        if let body = body {
            if let json = try? JSONSerialization.jsonObject(with: body),
               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                bodyString = String(data: prettyData, encoding: .utf8) ?? "Invalid UTF8"
            } else {
                bodyString = "<Binary or Non-JSON Data: \(body.count) bytes>"
            }
        }
        
        logger.debug("""
        [REQUEST] 🚀
        → Method: \(method, privacy: .public)
        → URL: \(urlStr, privacy: .private)
        → Headers: \(headers, privacy: .private)
        → Body:
        \(bodyString, privacy: .private)
        """)
        #endif
    }

    static func response(_ req: URLRequest, resp: HTTPURLResponse, data: Data?) {
        #if DEBUG
        let method = req.httpMethod ?? "GET"
        let urlStr = req.url?.absoluteString ?? ""
        let statusCode = resp.statusCode
        
        var bodyString = "nil"
        if let data = data {
            if let json = try? JSONSerialization.jsonObject(with: data),
               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                bodyString = String(data: prettyData, encoding: .utf8) ?? "Invalid UTF8"
            } else {
                bodyString = "<Binary or Non-JSON Data: \(data.count) bytes>"
            }
        }
        
        if (200..<300).contains(statusCode) {
            logger.info("""
            [RESPONSE SUCCESS] ✅
            ← \(method, privacy: .public) \(statusCode, privacy: .public)
            ← URL: \(urlStr, privacy: .private)
            ← Body:
            \(bodyString, privacy: .private)
            """)
        } else {
            logger.error("""
            [RESPONSE ERROR] ❌
            ← \(method, privacy: .public) \(statusCode, privacy: .public)
            ← URL: \(urlStr, privacy: .private)
            ← Body:
            \(bodyString, privacy: .private)
            """)
        }
        #endif
    }
}
