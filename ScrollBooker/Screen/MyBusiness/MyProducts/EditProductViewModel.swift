//
//  EditProductViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class EditProductViewModel {
    let productId: Int
    let form: ProductFormViewModel

    private(set) var loadingState: FeatureState<Product> = .idle
    private(set) var isSaving = false
    var errorMessage: String?

    private let getProductByIdUseCase: GetProductByIdUseCase
    private let updateProductBaseInfoUseCase: UpdateProductBaseInfoUseCase
    private let createProductVariantUseCase: CreateProductVariantUseCase
    private let updateProductVariantUseCase: UpdateProductVariantUseCase
    private let deleteProductVariantUseCase: DeleteProductVariantUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "EditProduct")

    init(
        productId: Int,
        session: SessionManager,
        getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        getFiltersByServiceUseCase: GetFiltersByServiceUseCase,
        getProductByIdUseCase: GetProductByIdUseCase,
        updateProductBaseInfoUseCase: UpdateProductBaseInfoUseCase,
        createProductVariantUseCase: CreateProductVariantUseCase,
        updateProductVariantUseCase: UpdateProductVariantUseCase,
        deleteProductVariantUseCase: DeleteProductVariantUseCase
    ) {
        self.productId = productId
        self.getProductByIdUseCase = getProductByIdUseCase
        self.updateProductBaseInfoUseCase = updateProductBaseInfoUseCase
        self.createProductVariantUseCase = createProductVariantUseCase
        self.updateProductVariantUseCase = updateProductVariantUseCase
        self.deleteProductVariantUseCase = deleteProductVariantUseCase
        self.form = ProductFormViewModel(
            hasEmployees: session.userInfo?.hasEmployees ?? false,
            ownerUserId: session.userInfo?.businessOwnerId ?? session.userInfo?.id ?? 0,
            getSelectedDomainsByBusinessUseCase: getSelectedDomainsByBusinessUseCase,
            getEmployeesByOwnerUseCase: getEmployeesByOwnerUseCase,
            getFiltersByServiceUseCase: getFiltersByServiceUseCase
        )
    }

    func loadProduct() async {
        guard loadingState == .idle else { return }
        loadingState = .loading

        do {
            let product = try await withLoading {
                try await getProductByIdUseCase(productId: productId)
            }
            form.applyProduct(product)
            await form.loadInitialData(businessId: product.businessId, businessOwnerId: product.businessOwnerId)
            loadingState = .success(product)
        } catch {
            loadingState = .error(logger.userMessage(for: error, context: "Loading Product"))
        }
    }

    func updateBaseInfo() async -> Bool {
        guard !isSaving else { return false }
        guard form.isBaseInfoValid, form.missingFilterIds.isEmpty else { return false }

        isSaving = true
        errorMessage = nil
        defer { isSaving = false }

        let filters: [ProductFilterRequestDTO] = form.selectedFilters.compactMap { filterId, subFilterIds in
            guard !subFilterIds.isEmpty else { return nil }
            return ProductFilterRequestDTO(filterId: filterId, subFilterIds: Array(subFilterIds), isNotApplicable: false)
        }

        let trimmedDescription = form.description.trimmingCharacters(in: .whitespacesAndNewlines)

        let request = ProductBaseInfoUpdateRequestDTO(
            name: form.name,
            description: trimmedDescription.isEmpty ? nil : trimmedDescription,
            serviceDomainId: Int(form.serviceDomainId) ?? 0,
            serviceId: Int(form.serviceId) ?? 0,
            canBeBooked: true,
            type: ProductTypeEnum.single.rawValue,
            sessionsCount: nil,
            validityDays: nil,
            filters: filters
        )

        do {
            _ = try await updateProductBaseInfoUseCase(productId: productId, request: request)
            return true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Updating Product")
            return false
        }
    }

    func saveVariant(_ variant: ProductVariantFormState) async {
        let request = ProductVariantCreateRequestDTO(
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

        do {
            let updatedProduct: Product
            if let backendId = variant.backendId {
                updatedProduct = try await updateProductVariantUseCase(
                    productId: productId,
                    variantId: backendId,
                    request: request
                )
            } else {
                updatedProduct = try await createProductVariantUseCase(productId: productId, request: request)
            }
            form.applyVariants(from: updatedProduct)
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Saving Variant")
        }
    }

    func deleteVariant(_ variant: ProductVariantFormState) async {
        guard let backendId = variant.backendId else {
            form.removeVariant(id: variant.id)
            return
        }

        do {
            try await deleteProductVariantUseCase(productId: productId, variantId: backendId)
            form.removeVariant(id: variant.id)
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Deleting Variant")
        }
    }
}
