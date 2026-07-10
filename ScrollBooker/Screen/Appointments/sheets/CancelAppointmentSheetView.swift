//
//  CancelAppointmentSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

enum AppointmentCancelReason: String, CaseIterable, Identifiable, Hashable {
    case cannotArrive = "CANNOT_ARRIVE"
    case foundBetterOffer = "FOUND_BETTER_OFFER"
    case bookedByMistake = "BOOKED_BY_MISTAKE"
    case other = "OTHER"
    
    var id: String { rawValue }
    
    var localizationKey: String {
        switch self {
        case .cannotArrive: return "reasonCancel_cannotArrive"
        case .foundBetterOffer: return "reasonCancel_foundBetterOffer"
        case .bookedByMistake: return "reasonCancel_bookedByMistake"
        case .other: return "others"
        }
    }
}

import SwiftUI

struct CancelAppointmentSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var onConfirmCancel: (String) async -> Void
    
    @State private var message: String = ""
    @State private var selectedReason: AppointmentCancelReason = .other
    
    @State private var isSaving = false
    
    private let maxLength = 100
    private var isOtherReason: Bool { selectedReason == .other }
    
    private var isButtonEnabled: Bool {
        let hasContent = isOtherReason ? !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty : true
        return hasContent && message.count <= maxLength && !isSaving
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(title: String(localized: "cancelAppointment"))
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(AppointmentCancelReason.allCases.enumerated()), id: \.element.id) { index, reason in
                        InputRadio(
                            title: String(localized: LocalizedStringResource(stringLiteral: reason.localizationKey)),
                            isSelected: reason == selectedReason,
                            onClick: {
                                guard !isSaving else { return } // Blocăm interacțiunea în loading
                                selectedReason = reason
                                if reason != .other { message = "" }
                            }
                        )
                        
                        if index < AppointmentCancelReason.allCases.count - 1 {
                            Divider()
                                .padding(.horizontal, .xl)
                        }
                    }
                    
                    if isOtherReason {
                        TextField(String(localized: "writeCancelReason"), text: $message, axis: .vertical)
                            .lineLimit(5, reservesSpace: true)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                            .padding(.top, .base)
                            .disabled(isSaving)
                    }
                }
                .padding(.base)
            }
            
            VStack(spacing: 0) {
                Divider()
                
                MainButton(
                    title: String(localized: "cancelAppointment"),
                    onClick: {
                        Task {
                            isSaving = true
                            
                            let finalMessage = isOtherReason ? message : String(localized: LocalizedStringResource(stringLiteral: selectedReason.localizationKey))
                            
                            await onConfirmCancel(finalMessage)
                            
                            isSaving = false
                            dismiss()
                        }
                    },
                    isDisabled: !isButtonEnabled,
                    isLoading: isSaving,
                    bgColor: .errorSB
                )
                .padding(.base)
            }
            .background(Color.backgroundSB)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedReason)
    }
}

