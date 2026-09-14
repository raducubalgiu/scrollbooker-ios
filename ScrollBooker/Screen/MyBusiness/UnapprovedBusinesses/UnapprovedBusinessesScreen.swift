//
//  UnapprovedBusinessesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct UnapprovedBusinessesScreen: View {
    let viewModel: UnapprovedBusinessesViewModel
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: String(localized: "my_business_unapproved"), onBack: onBack)

            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()

                case .error:
                    ErrorView(message: String(localized: "somethingWentWrong")) {
                        Task { await viewModel.refresh() }
                    }

                case .success(let items):
                    if items.isEmpty {
                        NoDataView(
                            title: String(localized: "my_business_unapproved"),
                            message: String(localized: "my_business_unapproved_empty"),
                            systemImage: "building.2"
                        )
                    } else {
                        UnapprovedBusinessesListView(
                            businesses: items,
                            isPaging: viewModel.isPaging,
                            approvingBusinessId: viewModel.approvingBusinessId,
                            onRefresh: { await viewModel.refresh() },
                            onItemAppear: { item in
                                Task {
                                    await viewModel.loadMoreIfNeeded(currentItem: item)
                                }
                            },
                            onApprove: { item in
                                Task {
                                    await viewModel.approveBusiness(userId: item.id)
                                }
                            }
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.initialLoadIfNeeded()
        }
        .alert(
            String(localized: "somethingWentWrong"),
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {}
    }
}
