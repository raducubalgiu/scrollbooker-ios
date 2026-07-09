//
//  CreateProblemUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.07.2026.
//

import Foundation

final class CreateProblemUseCase {
    private let repository: ProblemRepository

    init(repository: ProblemRepository) {
        self.repository = repository
    }

    func callAsFunction(
        text: String,
        userId: Int
    ) async throws -> Problem {
        let request = ReportProblemRequest(text: text, user_id: userId)
        
        return try await repository.createProblem(
            request: request
        )
    }
}
