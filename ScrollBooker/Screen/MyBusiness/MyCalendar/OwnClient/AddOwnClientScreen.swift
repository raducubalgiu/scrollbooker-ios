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

    @State private var showClientSelect = false
    @State private var showCreateClient = false
    @State private var showServicesSelect = false
    @State private var showDateTimeSelect = false

    private static let slotDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private var selectedSlotLabel: String? {
        guard let slot = viewModel.selectedSlot,
              let date = Self.slotDateFormatter.date(from: slot.startDateLocale) else { return nil }
        return date.formatted(.dateTime.day().month(.wide).hour().minute())
    }

    private var bottomButtonTitle: String {
        viewModel.selectedSlot != nil ? String(localized: "save") : String(localized: "selectDateAndTime")
    }

    private var isBottomButtonDisabled: Bool {
        viewModel.selectedSlot != nil ? !viewModel.canSave : !viewModel.canPickDateTime
    }

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: String(localized: "addAppointment"), onBack: onBack)

            AddOwnClientFormView(
                selectedClient: viewModel.selectedClient,
                linkedItems: viewModel.linkedItems,
                onOpenClientSelect: { showClientSelect = true },
                onRemoveService: { viewModel.removeLinkedItem($0) },
                onAddService: { showServicesSelect = true }
            )

            VStack(spacing: 0) {
                Divider()

                if let selectedSlotLabel {
                    Text(selectedSlotLabel)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, .s)
                }

                MainButton(
                    title: bottomButtonTitle,
                    isDisabled: isBottomButtonDisabled,
                    isLoading: viewModel.isSaving,
                    onClick: {
                        if viewModel.selectedSlot != nil {
                            Task {
                                if await viewModel.createAppointment() {
                                    onSaved()
                                }
                            }
                        } else {
                            showDateTimeSelect = true
                        }
                    }
                )
                .padding(.base)
            }
            .background(Color.backgroundSB)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundSB)
        .task {
            await viewModel.loadUserProducts()
        }
        .sheet(isPresented: $showClientSelect) {
            AddOwnClientClientSelectSheetView(
                clientsState: viewModel.clientsState,
                query: viewModel.clientQuery,
                onQueryChanged: { viewModel.updateClientQuery($0) },
                onSelect: { client in
                    viewModel.selectClient(client)
                    showClientSelect = false
                },
                onAddNewClient: {
                    showClientSelect = false
                    showCreateClient = true
                },
                onClose: { showClientSelect = false }
            )
            .presentationDetents([.fraction(0.75), .large])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(25)
        }
        .sheet(isPresented: $showCreateClient) {
            AddOwnClientCreateClientSheetView(
                isSaving: viewModel.isCreatingClient,
                onSave: { fullname, phone in
                    if await viewModel.createClient(fullname: fullname, phone: phone) {
                        showCreateClient = false
                    }
                }
            )
            .presentationDetents([.fraction(0.6), .large])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(25)
        }
        .sheet(isPresented: $showServicesSelect) {
            AddOwnClientServicesSheetView(
                userProductsState: viewModel.userProductsState,
                linkedItems: viewModel.linkedItems,
                onSelectBookingItem: { viewModel.selectBookingItem($0) },
                onClose: { showServicesSelect = false },
                onRetry: { Task { await viewModel.loadUserProducts() } }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(25)
        }
        .sheet(isPresented: $showDateTimeSelect) {
            AddOwnClientDateTimeSheetView(viewModel: viewModel)
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(25)
        }
    }
}
