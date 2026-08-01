//
//  ProfileInfoTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfileAboutTabView: View {
    let controller: ProfileController
    let userId: Int

    var body: some View {
        switch controller.aboutViewState {
        case .idle, .loading:
            LoadingView(maxHeight: 500)

        case .error(let message):
            ErrorView(message: message, maxHeight: 500) {
                Task { await controller.loadInitialAbout(userId: userId) }
            }

        case .success(let about):
            ProfileAboutSuccessView(
                about: about,
                isEmployee: false,
                onNavigateToUserProfile: { _, _ in }
            )
        }
    }
}
