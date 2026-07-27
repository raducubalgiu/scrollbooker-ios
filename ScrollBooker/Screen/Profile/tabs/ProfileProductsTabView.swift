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
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)

                case .error(let message):
                    ErrorView(message: message) {
                        Task {
                            await controller.loadInitialProducts(businessId: businessId, employeeId: employeeId)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)

                case .success(let products):
                    Text("Products loaded")
                }
            } else {
                NoDataView(
                    title: "No data", message: "No data"
                )
                .frame(maxWidth: .infinity, minHeight: 200)
            }
        }
        .task(id: businessId) {
            guard let businessId else { return }
            await controller.loadInitialProducts(businessId: businessId, employeeId: employeeId)
        }
    }
}
