//
//  ProblemApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.07.2026.
//

import Foundation

protocol ProblemApiService: Sendable {
    func reportProblem(request: ReportProblemRequest) async throws -> Problem
}

final class ProblemAPIImpl: ProblemApiService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func reportProblem(request: ReportProblemRequest) async throws -> Problem {
        return try await client.request(
            "problems",
            method: .post,
            body: request
        )
    }
}
