//
//  MyServicesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct MyServicesScreen: View {
    let viewModel: MyServicesViewModel
    var onBack: () -> Void
    
    private var isButtonDisabled: Bool {
        viewModel.isSaving || viewModel.selectedServiceIds.isEmpty || !viewModel.hasChanges
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "services"),
            subHeadline: String(localized: "addYourBusinessServices"),
            enableBottomButton: true,
            enableBack: true,
            buttonTitle: String(localized: "save"),
            isDisabled: isButtonDisabled,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: {
                Task {
                    await viewModel.updateBusinessServices()
                }
            }
        ) {
            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error:
                    ErrorView(message: String(localized: "somethingWentWrong")) {
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
