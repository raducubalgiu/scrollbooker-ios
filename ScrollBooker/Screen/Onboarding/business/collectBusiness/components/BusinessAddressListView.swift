//
//  BusinessAddressListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import SwiftUI

struct BusinessAddressListView: View {
    let addresses: [BusinessAddress]
    let selectedAddress: BusinessAddress?
    let onSelect: (BusinessAddress) -> Void

    var body: some View {
        List {
            ForEach(Array(addresses.enumerated()), id: \.element.id) { index, address in
                VStack(spacing: 0) {
                    InputRadio(
                        title: address.description,
                        isSelected: selectedAddress?.placeId == address.placeId,
                        leadingIcon: Image(systemName: "magnifyingglass"),
                        onClick: { onSelect(address) }
                    )

                    if index < addresses.count - 1 {
                        Divider()
                            .opacity(0.5)
                            .padding(.vertical, .base)
                    }
                }
                .padding(.horizontal, .xxl)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
    }
}
