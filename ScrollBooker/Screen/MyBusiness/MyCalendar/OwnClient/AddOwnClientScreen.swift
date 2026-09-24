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

    private static let slotDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private var selectedSlotLabel: String? {
        guard let slot = viewModel.selectedSlot,
              let start = Self.slotDateFormatter.date(from: slot.startDateLocale),
              let end = Self.slotDateFormatter.date(from: slot.endDateLocale) else { return nil }

        let datePart = start.formatted(.dateTime.day().month(.wide))
        let startTime = start.formatted(.dateTime.hour().minute())
        let endTime = end.formatted(.dateTime.hour().minute())

        if let duration = viewModel.selectedSlotDurationMinutes {
            return "\(datePart), \(startTime) - \(endTime) (\(duration) min)"
        }
        return "\(datePart), \(startTime)"
    }

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

            VStack(spacing: 0) {
                Divider()

                HStack {
                    Text("\(String(localized: "duration")): \(viewModel.totalDuration) min")
                        .font(.subheadline.weight(.medium))

                    Spacer()

                    Text("\(String(localized: "total")): \(viewModel.totalPriceWithDiscount.toTwoDecimals()) RON")
                        .font(.subheadline.weight(.medium))
                }
                .padding(.horizontal, .base)
                .padding(.vertical, .s)

                AddOwnClientDateTimeSummaryButtonView(
                    value: selectedSlotLabel,
                    isEnabled: viewModel.totalDuration > 0,
                    onClick: { activeSheet = .dateTimeSelect }
                )
                .padding(.horizontal, .base)

                if viewModel.hasDurationMismatch, let mismatchDuration = viewModel.selectedSlotDurationMinutes {
                    Text(String(format: String(localized: "appointmentDurationMismatch"), viewModel.totalDuration, mismatchDuration))
                        .font(.footnote)
                        .foregroundColor(.errorSB)
                        .padding(.horizontal, .base)
                        .padding(.top, .xs)
                }

                MainButton(
                    title: String(localized: "saveAppointment"),
                    isDisabled: !viewModel.canSave,
                    isLoading: viewModel.isSaving,
                    onClick: {
                        Task {
                            if await viewModel.createAppointment() {
                                onSaved()
                            }
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
