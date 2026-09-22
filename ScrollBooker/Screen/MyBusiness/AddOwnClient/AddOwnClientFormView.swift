//
//  AddOwnClientFormView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct AddOwnClientFormView: View {
    let selectedClient: BusinessClient?
    let linkedItems: [SelectedBookingItem]
    var onOpenClientSelect: () -> Void
    var onRemoveService: (SelectedBookingItem) -> Void
    var onAddService: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSize.xl.rawValue) {
                AddOwnClientClientSectionView(selectedClient: selectedClient, onTap: onOpenClientSelect)

                AddOwnClientServicesSectionView(
                    linkedItems: linkedItems,
                    onRemove: onRemoveService,
                    onAddService: onAddService
                )
            }
            .padding(.base)
        }
    }
}
