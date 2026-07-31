//
//  MyProductsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class MyProductsViewModel {
    private(set) var viewState: FeatureState<UserProducts> = .idle
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Products")
    
    private let session: SessionManager
    private let getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase
    
    init(
        session: SessionManager,
        getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase
    ) {
        self.session = session
        self.getProductsByBusinessAndEmployeeUseCase = getProductsByBusinessAndEmployeeUseCase
    }
    
    func loadProducts() async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        
        guard let businessId = session.userInfo?.businessId else {
            logger.error("ERROR: Business ID not found in session")
            viewState = .error("Something went wrong")
            return
        }
        
        do {
            let productsData = try await withLoading {
                try await getProductsByBusinessAndEmployeeUseCase(
                    businessId: businessId,
                    employeeId: nil,
                    onlyServicesWithProducts: false,
                    productsLimitPerService: nil
                )
            }
            
            viewState = .success(productsData)
        } catch {
            logger.error("ERROR: on Fetching Products: \(error.localizedDescription)")
            viewState = .error("Something went wrong")
        }
    }
}

