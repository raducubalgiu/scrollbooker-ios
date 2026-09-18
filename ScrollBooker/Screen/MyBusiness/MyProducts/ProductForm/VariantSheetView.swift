//
//  VariantSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import SwiftUI

struct VariantSheetView: View {
    let form: ProductFormViewModel
    var onSave: (ProductVariantFormState) -> Void
    var onDelete: (() -> Void)?

    @State private var variant: ProductVariantFormState
    @State private var showErrors = false
    @Environment(\.dismiss) private var dismiss

    init(form: ProductFormViewModel, variant: ProductVariantFormState, onSave: @escaping (ProductVariantFormState) -> Void, onDelete: (() -> Void)? = nil) {
        self.form = form
        self.onSave = onSave
        self.onDelete = onDelete
        self._variant = State(initialValue: variant)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSize.m.rawValue) {
                    Input(
                        label: String(localized: "name"),
                        text: $variant.name,
                        isError: showErrors && !variant.isNameValid,
                        errorMessage: "Numele trebuie să aibă 2-50 caractere"
                    )

                    Input(
                        label: "Durată (minute)",
                        text: $variant.duration,
                        isError: showErrors && !variant.isDurationValid,
                        keyboardType: .numberPad,
                        errorMessage: "Durata este obligatorie"
                    )

                    Text("Prețuri")
                        .font(.subheadline.bold())
                        .padding(.top, .s)

                    if form.hasEmployees {
                        employeesPricesSection
                    } else {
                        singlePriceSection
                    }

                    if showErrors && !variant.hasSelectedOffering {
                        Text("Selectează cel puțin un preț")
                            .font(.caption)
                            .foregroundColor(.errorSB)
                    }
                }
                .padding(.base)
            }
            .navigationTitle("Opțiune")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Închide") { dismiss() }
                }
                if let onDelete {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .destructive) {
                            onDelete()
                            dismiss()
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                VStack(spacing: 0) {
                    Divider()
                    MainButton(title: String(localized: "save")) {
                        showErrors = true
                        guard variant.isValid else { return }
                        onSave(variant)
                        dismiss()
                    }
                    .padding(.base)
                }
                .background(Color.backgroundSB)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private var employeesPricesSection: some View {
        let employees = form.employeesViewState.data ?? []

        return VStack(spacing: AppSize.m.rawValue) {
            ForEach(variant.offerings.indices, id: \.self) { index in
                if let employee = employees.first(where: { $0.id == variant.offerings[index].userId }) {
                    EmployeeOfferingRowView(employee: employee, offering: $variant.offerings[index])
                }
            }
        }
    }

    @ViewBuilder
    private var singlePriceSection: some View {
        if !variant.offerings.isEmpty {
            OfferingPriceFieldsView(offering: $variant.offerings[0])
        }
    }
}

private struct EmployeeOfferingRowView: View {
    let employee: Employee
    @Binding var offering: ProductOfferingFormState

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
            Button {
                offering.isSelected.toggle()
            } label: {
                HStack(spacing: AppSize.s.rawValue) {
                    AvatarView(imageURL: employee.avatarURL, size: .s)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(employee.fullName)
                            .font(.subheadline.bold())
                            .foregroundColor(.onBackgroundSB)
                        Text(employee.job)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Image(systemName: offering.isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(offering.isSelected ? .primarySB : .gray)
                        .font(.title3)
                }
            }
            .buttonStyle(.plain)

            if offering.isSelected {
                OfferingPriceFieldsView(offering: $offering)
                    .padding(.leading, AppSize.xl.rawValue + AppSize.s.rawValue)
            }
        }
    }
}

private struct OfferingPriceFieldsView: View {
    @Binding var offering: ProductOfferingFormState

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
            HStack(spacing: AppSize.s.rawValue) {
                Input(
                    label: "Preț",
                    text: $offering.price,
                    isError: offering.isSelected && !(Decimal(string: offering.price).map { $0 > 0 } ?? false),
                    keyboardType: .decimalPad
                )

                Input(
                    label: "Discount %",
                    text: $offering.discount,
                    keyboardType: .decimalPad
                )
            }

            Text("Preț cu discount: \(offering.priceWithDiscount)")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
