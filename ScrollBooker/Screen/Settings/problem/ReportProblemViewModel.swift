//
//  ReportProblemViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.07.2026.
//

import Foundation
import Observation

@Observable
final class ReportProblemViewModel {
    var text: String = ""
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var isSuccess: Bool = false
    
    private let createProblemUseCase: CreateProblemUseCase
    private let userId: Int
    
    var isInputValid: Bool {
        text.count >= 20 && text.count <= 500
    }
    
    init(createProblemUseCase: CreateProblemUseCase, userId: Int) {
        self.createProblemUseCase = createProblemUseCase
        self.userId = userId
    }
    
    @MainActor
    func submitProblem() async {
        guard isInputValid else {
            errorMessage = "Textul trebuie să aibă între 20 și 500 de caractere."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let _ = try await createProblemUseCase(text: text, userId: userId)
            isSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
