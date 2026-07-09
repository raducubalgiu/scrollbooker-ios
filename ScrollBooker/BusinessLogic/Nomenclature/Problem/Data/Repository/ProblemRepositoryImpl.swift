//
//  ProblemRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.07.2026.
//

final class CreateProblemRepositoryImpl: ProblemRepository {
    private let apiService: ProblemApiService
    
    init(apiService: ProblemApiService) {
        self.apiService = apiService
    }
    
    func createProblem(request: ReportProblemRequest) async throws -> Problem {
        return try await apiService.reportProblem(request: request)
    }
}
