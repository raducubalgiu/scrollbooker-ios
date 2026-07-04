//
//  NetworkLogger.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation
import os

/// Logger de rețea ultra-performant și asincron, aliniat la standardele de securitate și concurență Apple.
enum NetworkLogger {
    // Definim un subsistem unic pentru modulul de rețea, facilitând filtrarea în Xcode Console și Apple Console app.
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.app.network", category: "Network")

    /// Loghează detaliile unei cereri HTTP trimise.
    static func request(_ req: URLRequest, body: Data?) {
        #if DEBUG
        let method = req.httpMethod ?? "GET"
        let urlStr = req.url?.absoluteString ?? ""
        
        // Cenzurăm sau mascăm token-urile sensibile pentru a preveni scurgerile de date (Security Compliance)
        var headers = req.allHTTPHeaderFields ?? [:]
        if headers["Authorization"] != nil {
            headers["Authorization"] = "Bearer [REDACTED/PROTECTED]"
        }
        
        var bodyString = "nil"
        if let body = body {
            // Verificăm dacă corpul este un JSON valid înainte de a-l printa, pentru a evita procesarea fișierelor binare
            if let json = try? JSONSerialization.jsonObject(with: body),
               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                bodyString = String(data: prettyData, encoding: .utf8) ?? "Invalid UTF8"
            } else {
                bodyString = "<Binary or Non-JSON Data: \(body.count) bytes>"
            }
        }
        
        // Utilizăm proprietatea structurală os.Logger pentru a trimite logurile asincron.
        // Folosim marcare de privacy: URL-ul este marcat ca privat în logurile de sistem consolidate.
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

    /// Loghează detaliile unui răspuns HTTP primit de la server.
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
        
        // Bifurcăm nivelul de log în funcție de codul de status pentru o scanare vizuală facilă în Xcode 15+
        if (200..<300).contains(statusCode) {
            logger.info("""
            [RESPONSE SUCCESS] ✅
            ← \(method, privacy: .public) \(statusCode, privacy: .public)
            ← URL: \(urlStr, privacy: .private)
            ← Body:
            \(bodyString, privacy: .private)
            """)
        } else {
            // Pentru erori (4xx, 5xx) folosim .error pentru a apărea cu roșu automat în Consola nativă
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
