//
//  NetworkLogger.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation
import os

enum NetworkLogger {
    enum Color: String {
        case cyan = "\u{001B}[0;36m"
        case green = "\u{001B}[0;32m"
        case yellow = "\u{001B}[0;33m"
        case red = "\u{001B}[0;31m"
        case reset = "\u{001B}[0;0m"
}

private static func write(_ text: String, color: Color) {
    #if DEBUG
    let colored = color.rawValue + text + Color.reset.rawValue + "\n"
    if let data = colored.data(using: .utf8) {
        FileHandle.standardOutput.write(data) // păstrează escape-urile
    }
    #endif
}

static func request(_ req: URLRequest, body: Data?) {
    var lines: [String] = []
    let method = req.httpMethod ?? "GET"
    let urlStr = req.url?.absoluteString ?? ""
    lines.append("→ \(method) \(urlStr)")
    lines.append("Headers: \(req.allHTTPHeaderFields ?? [:])")
    if let body = body, let s = String(data: body, encoding: .utf8) {
        lines.append("Body: \(s)")
    } else {
        lines.append("Body: nil")
}
    write("[REQUEST]\n" + lines.joined(separator: "\n"), color: .cyan)
}

    static func response(_ req: URLRequest, resp: HTTPURLResponse, data: Data?) {
    var lines: [String] = []
    let method = req.httpMethod ?? "GET"
    let urlStr = req.url?.absoluteString ?? ""
    lines.append("→ \(method) \(urlStr)")
    
    lines.append("Status: \(resp.statusCode)")
    if let data = data, let s = String(data: data, encoding: .utf8) {
        lines.append("Body:\n\(s)")
    } else if let data = data {
        lines.append("Body: <binary \(data.count) bytes>")
    } else {
        lines.append("Body: nil")
    }
    let color: Color = (200..<300).contains(resp.statusCode) ? .green : .red
    write("[RESPONSE]\n" + lines.joined(separator: "\n"), color: color)
    }
}
