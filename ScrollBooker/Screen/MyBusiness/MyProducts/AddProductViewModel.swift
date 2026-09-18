//
//  AddProductViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.07.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class AddProductViewModel {
    let form: ProductFormViewModel

    private(set) var isSaving = false
    var errorMessage: String?

    private let session: SessionManager
    private let createProductUseCase: CreateProductUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "AddProduct")

    init(
        session: SessionManager,
        getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        getFiltersByServiceUseCase: GetFiltersByServiceUseCase,
        createProductUseCase: CreateProductUseCase
    ) {
        self.session = session
        self.createProductUseCase = createProductUseCase
        self.form = ProductFormViewModel(
            hasEmployees: session.userInfo?.hasEmployees ?? false,
            ownerUserId: session.userInfo?.businessOwnerId ?? session.userInfo?.id ?? 0,
            getSelectedDomainsByBusinessUseCase: getSelectedDomainsByBusinessUseCase,
            getEmployeesByOwnerUseCase: getEmployeesByOwnerUseCase,
            getFiltersByServiceUseCase: getFiltersByServiceUseCase
        )
    }

    func loadInitialData() async {
        guard let businessId = session.userInfo?.businessId,
              let businessOwnerId = session.userInfo?.businessOwnerId else { return }

        await form.loadInitialData(businessId: businessId, businessOwnerId: businessOwnerId)
    }

    func createProduct() async -> Bool {
        guard !isSaving else { return false }
        guard form.isValid else { return false }
        guard let businessId = session.userInfo?.businessId else { return false }

        isSaving = true
        errorMessage = nil
        defer { isSaving = false }

        let filters: [ProductFilterRequestDTO] = form.selectedFilters.compactMap { filterId, subFilterIds in
            guard !subFilterIds.isEmpty else { return nil }
            return ProductFilterRequestDTO(filterId: filterId, subFilterIds: Array(subFilterIds), isNotApplicable: false)
        }

        let variants: [ProductVariantCreateRequestDTO] = form.variants.map { variant in
            ProductVariantCreateRequestDTO(
                name: variant.name,
                duration: Int(variant.duration) ?? 0,
                offerings: variant.selectedOfferings.map { offering in
                    ProductOfferingCreateRequestDTO(
                        userId: offering.userId,
                        price: Decimal(string: offering.price) ?? 0,
                        priceWithDiscount: offering.priceWithDiscount,
                        discount: Decimal(string: offering.discount.isEmpty ? "0" : offering.discount) ?? 0
                    )
                }
            )
        }

        let trimmedDescription = form.description.trimmingCharacters(in: .whitespacesAndNewlines)

        let productRequest = ProductCreateRequestDTO(
            name: form.name,
            description: trimmedDescription.isEmpty ? nil : trimmedDescription,
            serviceDomainId: Int(form.serviceDomainId) ?? 0,
            serviceId: Int(form.serviceId) ?? 0,
            businessId: businessId,
            currencyId: 1,
            canBeBooked: true,
            type: ProductTypeEnum.single.rawValue,
            sessionsCount: nil,
            validityDays: nil,
            variants: variants
        )

        do {
            _ = try await createProductUseCase(
                ProductCreateWithFiltersRequestDTO(product: productRequest, filters: filters)
            )
            return true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Creating Product")
            return false
        }
    }
}
