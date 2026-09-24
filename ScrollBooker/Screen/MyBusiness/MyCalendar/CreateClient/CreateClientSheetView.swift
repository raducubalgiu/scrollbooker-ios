//
//  CreateClientSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct CreateClientSheetView: View {
    @Environment(\.dismiss) private var dismiss

    let isSaving: Bool
    var onSave: (String, String?) async -> Void

    @State private var fullname: String = ""
    @State private var phone: String = ""

    private let minLength = 3
    private let maxLength = 50

    private var trimmedName: String { fullname.trimmingCharacters(in: .whitespacesAndNewlines) }

    private var nameErrorMessage: String? {
        if trimmedName.isEmpty {
            return String(localized: "requiredValidationMessage")
        }
        if trimmedName.count < minLength {
            return String(format: String(localized: "minLengthValidationMessage"), minLength)
        }
        if trimmedName.count > maxLength {
            return String(format: String(localized: "maxLengthValidationMessage"), maxLength)
        }
        return nil
    }

    private var trimmedPhone: String { phone.trimmingCharacters(in: .whitespacesAndNewlines) }

    private var phoneErrorMessage: String? {
        guard !trimmedPhone.isEmpty else { return nil }

        let allowedCharacters = CharacterSet(charactersIn: "0123456789+ -")
        guard trimmedPhone.unicodeScalars.allSatisfy({ allowedCharacters.contains($0) }) else {
            return String(localized: "invalidPhoneValidationMessage")
        }

        let digitsOnly = trimmedPhone.filter(\.isNumber)
        guard (7...15).contains(digitsOnly.count) else {
            return String(localized: "invalidPhoneValidationMessage")
        }

        return nil
    }

    private var isValid: Bool { nameErrorMessage == nil && phoneErrorMessage == nil }

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(onDismiss: { dismiss() }, title: String(localized: "addNewClient"), showDivider: false)

            ScrollView {
                VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(localized: "clientName"))
                            .font(.footnote)
                            .foregroundColor(.gray)

                        TextField(String(localized: "name"), text: $fullname)
                            .padding()
                            .background(Color.surfaceSB)
                            .cornerRadius(12)
                            .onChange(of: fullname) { _, newValue in
                                if newValue.count > maxLength {
                                    fullname = String(newValue.prefix(maxLength))
                                }
                            }

                        if let nameErrorMessage {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.footnote)
                                    .foregroundColor(.errorSB)

                                Text(nameErrorMessage)
                                    .font(.footnote)
                                    .foregroundColor(.errorSB)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(localized: "phone"))
                            .font(.footnote)
                            .foregroundColor(.gray)

                        TextField(String(localized: "phone"), text: $phone)
                            .keyboardType(.phonePad)
                            .padding()
                            .background(Color.surfaceSB)
                            .cornerRadius(12)

                        if let phoneErrorMessage {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.footnote)
                                    .foregroundColor(.errorSB)

                                Text(phoneErrorMessage)
                                    .font(.footnote)
                                    .foregroundColor(.errorSB)
                            }
                        }
                    }
                }
                .padding(.base)
            }
            .frame(maxHeight: .infinity, alignment: .top)

            Divider()

            MainButton(
                title: String(localized: "save"),
                isDisabled: !isValid || isSaving,
                isLoading: isSaving,
                onClick: {
                    Task {
                        await onSave(trimmedName, trimmedPhone.isEmpty ? nil : trimmedPhone)
                    }
                }
            )
            .padding(.base)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
