//
//  ProblemRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.07.2026.
//

protocol ProblemRepository: Sendable {
    func createProblem(request: ReportProblemRequest) async throws -> Problem
}
