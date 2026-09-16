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
    let onNavigateToBookingFromProduct: (Product) -> Void

    var body: some View {
        Group {
            if let businessId {
                switch controller.productsState {
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
                        if products.data.isEmpty {
                            NoDataView(
                                title: String(localized: "services"),
                                message: String(localized: "message_empty_services"),
                                maxHeight: 500,
                                systemImage: "bag.circle"
                            )
                        } else {
                            ProfileProductsSuccessView(
                                products: products,
                                onNavigateToBookingFromProduct: onNavigateToBookingFromProduct
                            )
                        }
                    }

            } else {
                NoDataView(
                    title: String(localized: "services"),
                    message: String(localized: "message_empty_services"),
                    maxHeight: 500,
                    systemImage: "bag.circle"
                )
                .padding(.top, .xxl)
            }
        }
    }
}
