//
//  AddOwnClientServicesSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct AddOwnClientServicesSectionView: View {
    let linkedItems: [SelectedBookingItem]
    var onRemove: (SelectedBookingItem) -> Void
    var onAddService: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(String(localized: "services"))
                .font(.headline)
                .padding(.bottom, .s)

            if !linkedItems.isEmpty {
                VStack(spacing: 0) {
                    ForEach(linkedItems) { item in
                        AddOwnClientLinkedServiceRowView(item: item, onRemove: { onRemove(item) })

                        if item.id != linkedItems.last?.id {
                            Divider()
                        }
                    }
                }
                .padding(.base)
                .background(Color.surfaceSB)
                .cornerRadius(12)
                .padding(.bottom, .s)
            }

            Button(action: onAddService) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text(String(localized: "addServices"))
                    Spacer()
                }
                .foregroundColor(.primarySB)
                .padding(.base)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.dividerSB, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
}
