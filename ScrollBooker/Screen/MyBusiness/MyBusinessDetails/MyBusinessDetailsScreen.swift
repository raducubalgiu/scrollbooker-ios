//
//  MyBusinessDetailsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.07.2026.
//

import SwiftUI

struct MyBusinessDetailsScreen: View {
    let viewModel: MyBusinessDetailsViewModel
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "myBusiness"),
                onBack: onBack
            )

            Group {
                switch viewModel.businessDetailsState {
                case .idle, .loading:
                    LoadingView()

                case .error:
                    ErrorView(message: String(localized: "message_error_something_went_wrong")) {
                        Task { await viewModel.loadBusinessDetails() }
                    }

                case .success(let businessDetails):
                    MyBusinessDetailsSuccessView(businessDetails: businessDetails, viewModel: viewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.loadBusinessDetails()
        }
    }
}
