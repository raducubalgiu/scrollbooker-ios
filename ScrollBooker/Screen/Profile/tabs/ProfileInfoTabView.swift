//
//  ProfileInfoTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfileInfoTabView: View {
    let controller: ProfileController
    let userId: Int

    var body: some View {
        switch controller.aboutViewState {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, minHeight: 200)

        case .error(let message):
            ErrorView(message: message) {
                Task { await controller.loadInitialAbout(userId: userId) }
            }
            .frame(maxWidth: .infinity, minHeight: 200)

        case .success(let about):
            // TODO: layout real — trimite-mi structura UserProfileAbout și îl fac complet
            Text("About loaded")
        }
    }
}
