//
//  ClientListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.09.2026.
//

import SwiftUI

struct ClientListView: View {
    let viewModel: AddOwnClientViewModel
    @Binding var pendingSelection: BusinessClient?

    var body: some View {
        switch viewModel.clientsState {
            case .idle, .loading:
                LoadingView()

            case .error(let message):
                ErrorView(message: message, retryAction: { Task { await viewModel.loadClientsIfNeeded() } })

            case .success(let clients):
                if clients.isEmpty {
                    NoDataView(
                        title: String(localized: "selectClient"),
                        message: String(localized: "message_empty_clients"),
                        systemImage: "person.crop.circle.badge.questionmark"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(clients) { client in
                                ClientRowView(
                                    client: client,
                                    isSelected: pendingSelection?.id == client.id,
                                    onTap: { pendingSelection = client }
                                )
                                .onAppear {
                                    Task { await viewModel.loadMoreClientsIfNeeded(currentClient: client) }
                                }

                                if client.id != clients.last?.id {
                                    Divider()
                                        .padding(.vertical, .xs)
                                }
                            }

                            if viewModel.isLoadingMoreClients && viewModel.canLoadMoreClients {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                            }
                        }
                        .padding(.horizontal, .base)
                    }
                }
        }
    }
}
