//
//  MyCalendarBlockSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarBlockSheetView: View {
    @Environment(\.dismiss) private var dismiss

    let dayLabel: String
    let selectedSlots: Set<String>
    var onConfirmBlock: (String) async -> Void

    @State private var message: String = ""
    @State private var selectedReason: MyCalendarBlockReasonEnum = .other
    @State private var isSaving = false

    private let minLength = 3
    private let maxLength = 50

    private var isOtherReason: Bool { selectedReason == .other }
    private var trimmedMessage: String { message.trimmingCharacters(in: .whitespacesAndNewlines) }

    private var messageErrorMessage: String? {
        if trimmedMessage.isEmpty {
            return String(localized: "requiredValidationMessage")
        }
        if trimmedMessage.count < minLength {
            return String(format: String(localized: "minLengthValidationMessage"), minLength)
        }
        if trimmedMessage.count > maxLength {
            return String(format: String(localized: "maxLengthValidationMessage"), maxLength)
        }
        return nil
    }

    private var isMessageValid: Bool { messageErrorMessage == nil }

    private var isButtonEnabled: Bool {
        let hasValidContent = isOtherReason ? isMessageValid : true
        return hasValidContent && !isSaving
    }

    private var title: String {
        selectedSlots.count > 1 ? String(localized: "blockSelectedSlots") : String(localized: "blockSlot")
    }

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(onDismiss: { dismiss() }, title: title)

            ScrollView {
                VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                    Text(dayLabel)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    MyCalendarBlockSlotPillsView(startDateLocaleValues: selectedSlots)

                    Text(String(localized: "reason"))
                        .font(.headline)

                    FlowLayout(horizontalSpacing: AppSize.s.rawValue, verticalSpacing: AppSize.s.rawValue) {
                        ForEach(MyCalendarBlockReasonEnum.allCases, id: \.self) { reason in
                            MyCalendarBlockReasonChipView(
                                title: reason.label,
                                isSelected: reason == selectedReason,
                                onTap: {
                                    guard !isSaving else { return }
                                    selectedReason = reason
                                    if reason != .other { message = "" }
                                }
                            )
                        }
                    }

                    if isOtherReason {
                        VStack(alignment: .trailing, spacing: 4) {
                            TextField(String(localized: "addMessage"), text: $message, axis: .vertical)
                                .lineLimit(3, reservesSpace: true)
                                .padding()
                                .background(Color.surfaceSB)
                                .cornerRadius(12)
                                .disabled(isSaving)
                                .onChange(of: message) { _, newValue in
                                    if newValue.count > maxLength {
                                        message = String(newValue.prefix(maxLength))
                                    }
                                }

                            Text("\(message.count) / \(maxLength)")
                                .font(.footnote)
                                .foregroundColor(.gray)

                            if let messageErrorMessage {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.footnote)
                                        .foregroundColor(.errorSB)

                                    Text(messageErrorMessage)
                                        .font(.footnote)
                                        .foregroundColor(.errorSB)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                }
                .padding(.base)
            }

            VStack(spacing: 0) {
                Divider()

                MainButton(
                    title: String(localized: "block"),
                    isDisabled: !isButtonEnabled,
                    isLoading: isSaving,
                    bgColor: .errorSB.opacity(0.2),
                    color: .errorSB,
                    onClick: {
                        Task {
                            isSaving = true
                            let finalMessage = isOtherReason ? trimmedMessage : selectedReason.label
                            await onConfirmBlock(finalMessage)
                            isSaving = false
                            dismiss()
                        }
                    }
                )
                .padding(.base)
            }
            .background(Color.backgroundSB)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedReason)
    }
}
