//
//  CollectLocationPermissionScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectLocationPermissionScreen: View {
    @Bindable var viewModel: CollectLocationPermissionViewModel
    let onBack: () -> Void

    var body: some View {
        FormLayout(
            headline: String(localized: "locationPermission"),
            subHeadline: String(localized: "locationPermissionDescription"),
            enableBack: false,
            buttonTitle: String(localized: "allowLocationAccess"),
            isDisabled: viewModel.isSaving,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: { Task { await viewModel.requestLocationPermission() } }
        ) {
            VStack {
                Spacer()

                Image(systemName: "location.circle.fill")
                    .font(.system(size: 90))
                    .foregroundColor(.primarySB)

                Spacer()

                Button {
                    Task { await viewModel.skip() }
                } label: {
                    Text(String(localized: "notNow"))
                        .fontWeight(.semibold)
                }
                .disabled(viewModel.isSaving)
                .foregroundColor(.gray)
                .padding(.bottom, .xl)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
