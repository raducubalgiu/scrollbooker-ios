//
//  CollectBusinessServicesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct CollectBusinessServicesScreen: View {
    @Bindable var viewModel: CollectBusinessServicesViewModel
    let onBack: () -> Void

    var body: some View {
        FormLayout(
            headline: String(localized: "my_business_categories"),
            subHeadline: String(localized: "my_business_categories_full_description"),
            enableBack: true,
            buttonTitle: String(localized: "nextStep"),
            isDisabled: !viewModel.isSubmitEnabled,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: { Task { await viewModel.collectBusinessServices() } }
        ) {
            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()

                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.loadServices() }
                    }

                case .success(let domains):
                    MyServicesListView(
                        data: domains,
                        selectedServiceIds: viewModel.selectedServiceIds,
                        onToggleService: { serviceId in
                            viewModel.toggleService(serviceId: serviceId)
                        }
                    )
                }
            }
        }
        .task {
            await viewModel.loadServices()
        }
    }
}
