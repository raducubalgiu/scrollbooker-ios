//
//  CollectBusinessLocationScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct CollectBusinessLocationScreen: View {
    @Bindable var viewModel: CollectBusinessViewModel
    let onBack: () -> Void

    var body: some View {
        FormLayout(
            headline: String(localized: "onboarding_business_location_title"),
            subHeadline: String(localized: "onboarding_business_location_description"),
            enableBack: true,
            buttonTitle: String(localized: "nextStep"),
            isDisabled: !viewModel.isLocationStepValid,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: { Task { await viewModel.createBusiness() } }
        ) {
            VStack(spacing: 0) {
                SearchBarView(
                    text: $viewModel.addressQuery,
                    placeholder: String(localized: "onboarding_business_location_search_placeholder")
                )
                .padding(.leading, .xl)
                .padding(.trailing, .xxl)
                .padding(.bottom, .s)

                Group {
                    switch viewModel.addressSearchState {
                    case .idle:
                        EmptyView()

                    case .loading:
                        LoadingView()

                    case .error(let message):
                        ErrorView(message: message) {
                            viewModel.retryAddressSearch()
                        }

                    case .success(let addresses):
                        if addresses.isEmpty {
                            NoDataView(
                                title: String(localized: "onboarding_business_location_title"),
                                message: String(localized: "notFoundAnyResult"),
                                systemImage: "mappin.and.ellipse"
                            )
                        } else {
                            BusinessAddressListView(
                                addresses: addresses,
                                selectedAddress: viewModel.selectedAddress,
                                onSelect: { viewModel.selectedAddress = $0 }
                            )
                        }
                    }
                }
            }
        }
    }
}
