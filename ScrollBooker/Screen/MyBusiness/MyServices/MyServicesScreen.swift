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
