//
//  SelectClientSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct SelectClientSheetView: View {
    let viewModel: AddOwnClientViewModel
    var onAddNewClient: () -> Void
    var onClose: () -> Void

    @State private var pendingSelection: BusinessClient?

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(onDismiss: onClose, title: String(localized: "selectClient"), showDivider: false)

            SearchBarView(
                text: Binding(
                    get: { viewModel.clientQuery },
                    set: { viewModel.updateClientQuery($0) }
                ),
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

            ClientListView(viewModel: viewModel, pendingSelection: $pendingSelection)

            Divider()

            MainButton(
                title: String(localized: "add"),
                isDisabled: pendingSelection == nil,
                isLoading: false,
                onClick: {
                    if let pendingSelection {
                        viewModel.selectClient(pendingSelection)
                    }
                    onClose()
                }
            )
            .padding(.base)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            pendingSelection = viewModel.selectedClient
        }
    }
}
