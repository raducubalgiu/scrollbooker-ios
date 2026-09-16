//
//  CollectBusinessTypeScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectBusinessTypeScreen: View {
    @Bindable var viewModel: CollectBusinessViewModel
    let onNext: () -> Void

    var body: some View {
        FormLayout(
            headline: String(localized: "onboarding_business_type_title"),
            subHeadline: String(localized: "onboarding_business_type_description"),
            enableBack: false,
            buttonTitle: String(localized: "nextStep"),
            isDisabled: viewModel.selectedBusinessType == nil,
            onBack: {},
            onClick: onNext
        ) {
            Group {
                switch viewModel.businessTypesPaginator.viewState {
                case .idle, .loading:
                    LoadingView()

                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.businessTypesPaginator.refresh() }
                    }

                case .success(let businessTypes):
                    if businessTypes.isEmpty {
                        NoDataView(
                            title: String(localized: "onboarding_business_type_title"),
                            message: String(localized: "message_error_something_went_wrong"),
                            systemImage: "square.grid.2x2"
                        )
                    } else {
                        BusinessTypeListView(
                            businessTypes: businessTypes,
                            selectedBusinessType: viewModel.selectedBusinessType,
                            isPaging: viewModel.businessTypesPaginator.isPaging,
                            onSelect: { viewModel.selectedBusinessType = $0 },
                            onLoadMore: { businessType in
                                Task {
                                    await viewModel.businessTypesPaginator.loadMoreIfNeeded(currentItem: businessType)
                                }
                            },
                            onRefresh: { await viewModel.businessTypesPaginator.refresh() }
                        )
                    }
                }
            }
        }
        .task {
            await viewModel.businessTypesPaginator.loadInitialIfNeeded()
        }
    }
}
