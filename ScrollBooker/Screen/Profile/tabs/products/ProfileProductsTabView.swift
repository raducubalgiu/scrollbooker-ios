//
//  ProfileProductsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfileProductsTabView: View {
    let controller: ProfileController
    let businessId: Int?
    let employeeId: Int?

    var body: some View {
        Group {
            if let businessId {
                switch controller.productsViewState {
                    case .idle, .loading:
                        LoadingView(maxHeight: 500)

                    case .error(let message):
                        ErrorView(message: message, maxHeight: 500) {
                            Task {
                                await controller.loadInitialProducts(
                                    businessId: businessId,
                                    employeeId: employeeId
                                )
                            }
                        }

                    case .success(let products):
                        ProfileProductsSuccessView(products: products)
                    }
                
            } else {
                NoDataView(
                    title: "No data", 
                    message: "No data",
                    maxHeight: 500
                )
            }
        }
        .task(id: businessId) {
            guard let businessId else { return }
            await controller.loadInitialProducts(businessId: businessId, employeeId: employeeId)
        }
    }
}
