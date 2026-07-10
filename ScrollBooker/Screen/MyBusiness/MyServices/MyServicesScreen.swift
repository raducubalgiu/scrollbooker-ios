//
//  MyServicesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct MyServicesScreen: View {
    let viewModel: MyServicesViewModel
    
    private var isButtonDisabled: Bool {
        viewModel.isLoading || viewModel.selectedServiceIds.isEmpty || !viewModel.hasChanges
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "services"),
            subHeadline: String(localized: "addYourBusinessServices"),
            enableBottomButton: true,
            enableBack: true,
            buttonTitle: String(localized: "save"),
            isDisabled: isButtonDisabled,
            isLoading: viewModel.isLoading,
            onClick: {
                Task {
                    await viewModel.updateBusinessServices()
                }
            }
        ) {
            VStack {
                if viewModel.isLoading && viewModel.uiState.data.isEmpty {
                    LoadingView()
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(message: errorMessage) {
                        Task { await viewModel.loadServices() }
                    }
                } else {
                    MyServicesListView(
                        data: viewModel.uiState.data,
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
