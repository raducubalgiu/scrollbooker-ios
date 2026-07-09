//
//  ProblemModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.07.2026.
//

import Foundation

@MainActor
final class ProblemModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: ProblemApiService = {
        ProblemAPIImpl(client: apiClient)
    }()

    private lazy var repository: ProblemRepository = {
        CreateProblemRepositoryImpl(apiService: apiService)
    }()

    private lazy var createProblem: CreateProblemUseCase = {
        CreateProblemUseCase(repository: repository)
    }()

    func makeProblemViewModel(userId: Int) -> ReportProblemViewModel {
        ReportProblemViewModel(
            createProblemUseCase: createProblem,
            userId: userId
        )
    }
}
