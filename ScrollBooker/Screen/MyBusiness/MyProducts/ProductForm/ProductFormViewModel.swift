//
//  ProductFormViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import Foundation
import Observation

// Shared by AddProductViewModel and (later) EditProductViewModel — mirrors Android's
// base ProductViewModel, held by composition rather than subclassed (Observation's
// tracking doesn't reliably propagate to a plain, non-@Observable subclass).
@Observable
@MainActor
final class ProductFormViewModel {
    var name: String = ""
    var description: String = ""

    var serviceDomainId: String = "" {
        didSet {
            guard oldValue != serviceDomainId else { return }
            serviceId = ""
        }
    }

    var serviceId: String = "" {
        didSet {
            guard oldValue != serviceId else { return }
            selectedFilters = [:]
            loadFilters()
        }
    }

    var variants: [ProductVariantFormState] = []
    var selectedFilters: [Int: Set<Int>] = [:]

    private(set) var domainsViewState: FeatureState<[SelectedServiceDomainsWithServices]> = .idle
    private(set) var employeesViewState: FeatureState<[Employee]> = .idle
    private(set) var filtersViewState: FeatureState<[Filter]> = .idle

    let hasEmployees: Bool
    let ownerUserId: Int

    private let getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase
    private let getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase
    private let getFiltersByServiceUseCase: GetFiltersByServiceUseCase

    init(
        hasEmployees: Bool,
        ownerUserId: Int,
        getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        getFiltersByServiceUseCase: GetFiltersByServiceUseCase
    ) {
        self.hasEmployees = hasEmployees
        self.ownerUserId = ownerUserId
        self.getSelectedDomainsByBusinessUseCase = getSelectedDomainsByBusinessUseCase
        self.getEmployeesByOwnerUseCase = getEmployeesByOwnerUseCase
        self.getFiltersByServiceUseCase = getFiltersByServiceUseCase
    }

    func loadInitialData(businessId: Int, businessOwnerId: Int) async {
        async let domains: () = loadDomains(businessId: businessId)
        async let employees: () = loadEmployees(businessOwnerId: businessOwnerId)
        _ = await (domains, employees)
    }

    private func loadDomains(businessId: Int) async {
        guard domainsViewState == .idle else { return }
        domainsViewState = .loading

        do {
            let domains = try await withLoading {
                try await getSelectedDomainsByBusinessUseCase(businessId: businessId)
            }
            domainsViewState = .success(domains)
        } catch {
            domainsViewState = .error(error.localizedDescription)
        }
    }

    private func loadEmployees(businessOwnerId: Int) async {
        guard hasEmployees else {
            employeesViewState = .success([])
            return
        }
        guard employeesViewState == .idle else { return }
        employeesViewState = .loading

        do {
            let employees = try await getEmployeesByOwnerUseCase(businessOwnerId: businessOwnerId)
            employeesViewState = .success(employees)
        } catch {
            employeesViewState = .error(error.localizedDescription)
        }
    }

    private func loadFilters() {
        guard let serviceIdInt = Int(serviceId) else {
            filtersViewState = .success([])
            return
        }

        filtersViewState = .loading

        Task {
            do {
                let filters = try await getFiltersByServiceUseCase(serviceId: serviceIdInt)
                filtersViewState = .success(filters)
            } catch {
                filtersViewState = .error(error.localizedDescription)
            }
        }
    }

    var categories: [SelectOption] {
        guard let domains = domainsViewState.data else { return [] }
        return domains
            .filter { domain in domain.services.contains { $0.isSelected } }
            .map { SelectOption(value: String($0.id), name: $0.name) }
    }

    var filteredServices: [SelectOption] {
        guard let domainIdInt = Int(serviceDomainId), let domains = domainsViewState.data else { return [] }
        let domain = domains.first { $0.id == domainIdInt }
        return (domain?.services ?? [])
            .filter(\.isSelected)
            .map { SelectOption(value: String($0.id), name: $0.name) }
    }

    var isNameValid: Bool {
        (3...100).contains(name.trimmingCharacters(in: .whitespacesAndNewlines).count)
    }

    var isBaseInfoValid: Bool {
        isNameValid && !serviceDomainId.isEmpty && !serviceId.isEmpty
    }

    var missingFilterIds: Set<Int> {
        guard let filters = filtersViewState.data else { return [] }
        return Set(filters.compactMap { filter in
            (selectedFilters[filter.id] ?? []).isEmpty ? filter.id : nil
        })
    }

    var isValid: Bool {
        isBaseInfoValid && !variants.isEmpty && variants.allSatisfy(\.isValid) && missingFilterIds.isEmpty
    }

    func setSelectedSubFilters(filterId: Int, subFilterIds: Set<Int>) {
        selectedFilters[filterId] = subFilterIds
    }

    func makeNewVariant() -> ProductVariantFormState {
        let offerings: [ProductOfferingFormState]

        if hasEmployees {
            offerings = (employeesViewState.data ?? []).map {
                ProductOfferingFormState(userId: $0.id)
            }
        } else {
            offerings = [ProductOfferingFormState(userId: ownerUserId, isSelected: true)]
        }

        return ProductVariantFormState(offerings: offerings)
    }

    func addVariant(_ variant: ProductVariantFormState) {
        variants.append(variant)
    }

    func updateVariant(_ variant: ProductVariantFormState) {
        guard let index = variants.firstIndex(where: { $0.id == variant.id }) else { return }
        variants[index] = variant
    }

    func removeVariant(id: UUID) {
        variants.removeAll { $0.id == id }
    }

    // Variant edit sheets always render one row per employee — pad the variant's saved
    // offerings (only the ones that already existed) out to the full roster so an unselected
    // employee still shows up, unchecked. A no-op for Add, whose variants are already full.
    func expandedOfferings(for variant: ProductVariantFormState) -> [ProductOfferingFormState] {
        guard hasEmployees else { return variant.offerings }

        return (employeesViewState.data ?? []).map { employee in
            variant.offerings.first { $0.userId == employee.id } ?? ProductOfferingFormState(userId: employee.id)
        }
    }

    func applyProduct(_ product: Product) {
        name = product.name
        description = product.description ?? ""

        serviceDomainId = String(product.serviceDomainId)
        serviceId = String(product.serviceId)
        selectedFilters = Dictionary(uniqueKeysWithValues: product.filters.map { filter in
            (filter.id, Set(filter.subFilters.map(\.id)))
        })

        applyVariants(from: product)
    }

    func applyVariants(from product: Product) {
        variants = product.variants.map { variant in
            ProductVariantFormState(
                backendId: variant.id,
                name: variant.name,
                duration: String(variant.duration),
                offerings: variant.offerings.map { offering in
                    ProductOfferingFormState(
                        userId: offering.user.id,
                        isSelected: true,
                        price: "\(offering.price)",
                        discount: "\(offering.discount)"
                    )
                }
            )
        }
    }
}
