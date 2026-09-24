//
//  AddOwnClientScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct AddOwnClientScreen: View {
    @State var viewModel: AddOwnClientViewModel
    var onBack: () -> Void
    var onSaved: () -> Void

    @State private var activeSheet: AddOwnClientSheet?

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "addAppointment"),
                enableBack: false,
                onBack: onBack,
                customAction: {
                    Button {
                        onBack()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.onBackgroundSB)
                    }
                }
            )

            AddOwnClientFormView(
                selectedClient: viewModel.selectedClient,
                linkedItems: viewModel.linkedItems,
                onOpenClientSelect: { activeSheet = .clientSelect },
                onAddNewClient: { activeSheet = .createClient },
                onRemoveService: { viewModel.removeLinkedItem($0) },
                onOpenServicesSheet: { activeSheet = .servicesSelect }
            )

            AddOwnClientBottomBarView(
                viewModel: viewModel,
                onOpenDateTimeSelect: { activeSheet = .dateTimeSelect },
                onSave: {
                    Task {
                        if await viewModel.createAppointment() {
                            onSaved()
                        }
                    }
                }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundSB)
        .task {
            async let products: Void = viewModel.loadUserProducts()
            async let clients: Void = viewModel.loadClientsIfNeeded()
            _ = await (products, clients)
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
                case .clientSelect:
                    SelectClientSheetView(
                        viewModel: viewModel,
                        onAddNewClient: { activeSheet = .createClient },
                        onClose: { activeSheet = nil }
                    )
                    .presentationDetents([.fraction(0.75), .large])
                    .presentationDragIndicator(.hidden)
                    .presentationCornerRadius(25)

                case .createClient:
                    CreateClientSheetView(
                        isSaving: viewModel.isCreatingClient,
                        onSave: { fullname, phone in
                            if await viewModel.createClient(fullname: fullname, phone: phone) {
                                activeSheet = nil
                            }
                        }
                    )
                    .presentationDetents([.fraction(0.6), .large])
                    .presentationDragIndicator(.hidden)
                    .presentationCornerRadius(25)

                case .servicesSelect:
                    AddOwnClientServicesSheetView(
                        userProductsState: viewModel.userProductsState,
                        linkedItems: viewModel.linkedItems,
                        onConfirm: { items in
                            viewModel.setLinkedItems(items)
                            activeSheet = nil
                        },
                        onClose: { activeSheet = nil },
                        onRetry: { Task { await viewModel.loadUserProducts() } }
                    )
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
                    .presentationCornerRadius(25)

                case .dateTimeSelect:
                    AddOwnClientDateTimeSheetView(viewModel: viewModel, onClose: { activeSheet = nil })
                        .presentationDetents([.large])
                        .presentationDragIndicator(.hidden)
                        .presentationCornerRadius(25)
            }
        }
    }
}
