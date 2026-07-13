//
//  MyProductsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import Foundation
import Observation

enum MyProductsState: Equatable {
    case idle
    case loading
    case success(UserProducts)
    case error(String)
}

@Observable
@MainActor
final class MyProductsViewModel: HasLoadingState {
    var uiState = UiState(data: [UserProducts]())
    
    private(set) var viewState: MyProductsState = .idle
    
    private let session: SessionManager
    private let getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase
    
    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return uiState.isLoading }
        set { uiState.isLoading = newValue }
    }

    var errorMessage: String? {
        get { if case .error(let msg) = viewState { return msg }; return uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }
    
    init(
        session: SessionManager,
        getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase,
    ) {
        self.session = session
        self.getProductsByBusinessAndEmployeeUseCase = getProductsByBusinessAndEmployeeUseCase
    }
    
    func loadProducts() async {
        guard viewState != .loading else { return }
        
        guard let businessId = session.userInfo?.businessId else {
            viewState = .error("Business ID not found in session")
            return
        }
        
        viewState = .loading
        uiState.errorMessage = nil
        
        do {
            let productsData = try await getProductsByBusinessAndEmployeeUseCase(
                businessId: businessId,
                employeeId: nil,
                onlyServicesWithProducts: false,
                productsLimitPerService: nil
            )
            
            viewState = .success(productsData)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
}
