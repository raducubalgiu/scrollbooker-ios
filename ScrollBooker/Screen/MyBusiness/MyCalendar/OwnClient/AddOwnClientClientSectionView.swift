//
//  AddOwnClientClientSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct AddOwnClientClientSectionView: View {
    let selectedClient: BusinessClient?
    var onOpenClientSelect: () -> Void
    var onAddNewClient: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(String(localized: "client"))
                    .font(.headline)

                Spacer()

                Button(action: onAddNewClient) {
                    HStack(spacing: AppSize.xxs.rawValue) {
                        Image(systemName: "plus.circle")
                        Text(String(localized: "addNewClient"))
                    }
                    .font(.subheadline)
                    .foregroundColor(.primarySB)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, .s)

            if let selectedClient {
                AddOwnClientSelectedClientRowView(client: selectedClient, onTap: onOpenClientSelect)
            } else {
                Button(action: onOpenClientSelect) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        Text(String(localized: "searchClientByNameOrPhone"))
                            .foregroundColor(.gray)

                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.surfaceSB)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
