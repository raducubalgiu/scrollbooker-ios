//
//  AddOwnClientClientSelectSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct AddOwnClientClientSelectSheetView: View {
    let clientsState: FeatureState<[BusinessClient]>
    let query: String
    var onQueryChanged: (String) -> Void
    var onSelect: (BusinessClient) -> Void
    var onAddNewClient: () -> Void
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(onDismiss: onClose, title: String(localized: "selectClient"), showDivider: false)

            SearchBarView(
                text: Binding(get: { query }, set: onQueryChanged),
                placeholder: String(localized: "searchClientByNameOrPhone")
            )
            .padding(.horizontal, .base)
            .padding(.top, .s)

            Button(action: onAddNewClient) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.primarySB)

                    Text(String(localized: "addNewClient"))
                        .foregroundColor(.primarySB)

                    Spacer()
                }
                .padding(.base)
            }
            .buttonStyle(.plain)

            Divider()

            content
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    @ViewBuilder
    private var content: some View {
        switch clientsState {
            case .idle:
                Spacer()

            case .loading:
                LoadingView()

            case .error(let message):
                ErrorView(message: message, retryAction: {})

            case .success(let clients):
                if clients.isEmpty {
                    NoDataView(
                        title: String(localized: "selectClient"),
                        message: String(localized: "message_empty_clients"),
                        systemImage: "person.crop.circle.badge.questionmark"
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(clients) { client in
                                Button(action: { onSelect(client) }) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(client.fullname)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.onBackgroundSB)

                                        if let phone = client.phone, !phone.isEmpty {
                                            Text(phone)
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, .s)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)

                                if client.id != clients.last?.id {
                                    Divider()
                                }
                            }
                        }
                        .padding(.horizontal, .base)
                    }
                }
        }
    }
}
