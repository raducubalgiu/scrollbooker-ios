//
//  RequestInterceptor.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

protocol RequestInterceptor: Sendable {
    func adapt(_ request: URLRequest) async throws -> URLRequest
    func retry(_ request: URLRequest, dueTo error: Error, attempts: Int) async throws -> Bool
}
