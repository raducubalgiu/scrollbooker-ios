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
    var onOpenServicesSheet: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(String(localized: "services"))
                    .font(.headline)

                Spacer()

                if !linkedItems.isEmpty {
                    Button(String(localized: "change"), action: onOpenServicesSheet)
                        .font(.footnote.bold())
                        .foregroundColor(.primarySB)
                }
            }
            .padding(.bottom, .s)

            if linkedItems.isEmpty {
                PlaceholderActionBoxView(
                    description: String(localized: "selectServicesForClient"),
                    onClick: onOpenServicesSheet
                )
            } else {
                VStack(spacing: AppSize.s.rawValue) {
                    ForEach(linkedItems) { item in
                        AddOwnClientLinkedServiceRowView(item: item, onRemove: { onRemove(item) })
                    }
                }
            }
        }
    }
}
