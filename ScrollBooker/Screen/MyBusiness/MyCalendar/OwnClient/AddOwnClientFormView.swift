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
    var onAddNewClient: () -> Void
    var onRemoveService: (SelectedBookingItem) -> Void
    var onOpenServicesSheet: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSize.xl.rawValue) {
                AddOwnClientClientSectionView(
                    selectedClient: selectedClient,
                    onOpenClientSelect: onOpenClientSelect,
                    onAddNewClient: onAddNewClient
                )

                AddOwnClientServicesSectionView(
                    linkedItems: linkedItems,
                    onRemove: onRemoveService,
                    onOpenServicesSheet: onOpenServicesSheet
                )
            }
            .padding(.base)
        }
    }
}
