//
//  ProductFormView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import SwiftUI

struct ProductFormView: View {
    let form: ProductFormViewModel
    var showErrors: Bool
    var onAddVariant: (ProductVariantFormState) -> Void
    var onUpdateVariant: (ProductVariantFormState) -> Void
    var onDeleteVariant: (ProductVariantFormState) -> Void

    @State private var activeVariant: ProductVariantFormState?
    @State private var isPresentingNewVariant = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.xl.rawValue) {
            baseInfoSection
            filtersSection
            variantsSection
        }
        .padding(.horizontal, .base)
        .padding(.top, .base)
        .padding(.bottom, AppSize.xxl.rawValue)
        .sheet(item: $activeVariant) { variant in
            VariantSheetView(
                form: form,
                variant: ProductVariantFormState(
                    backendId: variant.backendId,
                    name: variant.name,
                    duration: variant.duration,
                    offerings: form.expandedOfferings(for: variant)
                ),
                onSave: onUpdateVariant,
                onDelete: { onDeleteVariant(variant) }
            )
        }
        .sheet(isPresented: $isPresentingNewVariant) {
            VariantSheetView(
                form: form,
                variant: form.makeNewVariant(),
                onSave: onAddVariant
            )
        }
    }

    private var baseInfoSection: some View {
        VStack(alignment: .leading, spacing: AppSize.m.rawValue) {
            InputSelectView(
                placeholder: "Categorie",
                options: form.categories,
                selectedOption: form.serviceDomainId,
                onValueChange: { form.serviceDomainId = $0 }
            )

            InputSelectView(
                placeholder: "Serviciu",
                options: form.filteredServices,
                selectedOption: form.serviceId,
                onValueChange: { form.serviceId = $0 }
            )

            Input(
                label: String(localized: "name"),
                text: Binding(get: { form.name }, set: { form.name = $0 }),
                isError: showErrors && !form.isNameValid,
                errorMessage: "Numele trebuie să aibă 3-100 caractere"
            )

            Input(
                label: String(localized: "description"),
                text: Binding(get: { form.description }, set: { form.description = $0 })
            )
        }
    }

    @ViewBuilder
    private var filtersSection: some View {
        if let filters = form.filtersViewState.data, !filters.isEmpty {
            VStack(alignment: .leading, spacing: AppSize.m.rawValue) {
                ForEach(filters) { filter in
                    InputMultiSelectSheetView(
                        label: filter.name,
                        placeholder: "Alege \(filter.name)",
                        options: filter.subFilters.map { SelectSheetOption(value: String($0.id), name: $0.name) },
                        selectedValues: Set((form.selectedFilters[filter.id] ?? []).map(String.init)),
                        isSingleSelect: filter.singleSelect,
                        isError: showErrors && form.missingFilterIds.contains(filter.id),
                        errorMessage: "Selectează cel puțin o opțiune pentru \(filter.name)",
                        onConfirm: { newValues in
                            form.setSelectedSubFilters(filterId: filter.id, subFilterIds: Set(newValues.compactMap(Int.init)))
                        }
                    )
                }
            }
        } else if form.filtersViewState == .loading {
            ProgressView().frame(maxWidth: .infinity)
        }
    }

    private var isVariantsEnabled: Bool {
        !form.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !form.serviceDomainId.isEmpty
            && !form.serviceId.isEmpty
    }

    private var variantsSection: some View {
        VStack(alignment: .leading, spacing: AppSize.m.rawValue) {
            HStack {
                Text("Opțiuni și prețuri")
                    .font(.subheadline.bold())

                Spacer()

                Button("Adaugă") {
                    isPresentingNewVariant = true
                }
                .disabled(!isVariantsEnabled)
            }

            if form.variants.isEmpty {
                VStack(spacing: AppSize.s.rawValue) {
                    Text("Adaugă cel puțin o opțiune de preț")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSize.xl.rawValue)
                .background(Color.surfaceSB)
                .cornerRadius(12)

                if showErrors && form.variants.isEmpty {
                    Text("Este necesară cel puțin o opțiune")
                        .font(.caption)
                        .foregroundColor(.errorSB)
                }
            } else {
                VStack(spacing: AppSize.s.rawValue) {
                    ForEach(form.variants) { variant in
                        ProductVariantCardView(variant: variant)
                            .onTapGesture { activeVariant = variant }
                    }
                }
            }
        }
    }
}

private struct ProductVariantCardView: View {
    let variant: ProductVariantFormState

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(variant.name.isEmpty ? "Opțiune fără nume" : variant.name)
                    .font(.subheadline.bold())
                    .foregroundColor(.onBackgroundSB)

                Text(durationText)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            if let cheapest = variant.cheapestSelectedOffering {
                Text("\(cheapest.priceWithDiscount) lei")
                    .font(.subheadline.bold())
                    .foregroundColor(.onBackgroundSB)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.base)
        .background(Color.surfaceSB)
        .cornerRadius(12)
        .contentShape(Rectangle())
    }

    private var durationText: String {
        guard let minutes = Int(variant.duration), minutes > 0 else { return "" }
        let hours = minutes / 60
        let remaining = minutes % 60
        let hoursPart = hours > 0 ? "\(hours)h" : ""
        let minutesPart = remaining > 0 ? "\(remaining)min" : ""
        return [hoursPart, minutesPart].filter { !$0.isEmpty }.joined(separator: " ")
    }
}
