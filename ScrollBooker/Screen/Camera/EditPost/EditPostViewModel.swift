//
//  EditPostViewModel.swift
//  ScrollBooker
//

import Observation
import OSLog

@Observable
@MainActor
final class EditPostViewModel {
    let post: Post

    private(set) var viewState: FeatureState<Bool> = .idle

    var description: String
    var selectedServiceDomainId: String
    var linkedProducts: [Product] = []

    private(set) var serviceDomainsViewState: FeatureState<[SelectedServiceDomainsWithServices]> = .idle
    private(set) var userProductsViewState: FeatureState<UserProducts> = .idle

    private(set) var isSaving: Bool = false
    var errorMessage: String?

    var serviceDomainOptions: [SelectOption] {
        (serviceDomainsViewState.data ?? [])
            .filter { domain in domain.services.contains { $0.isSelected } }
            .map { SelectOption(value: String($0.id), name: $0.name) }
    }

    private var businessId: Int { post.businessId ?? post.businessOwner.id }

    private let updatePostUseCase: UpdatePostUseCase
    private let getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase
    private let getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase
    private let getPostLinkedProductsUseCase: GetPostLinkedProductsUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "EditPost")

    init(
        post: Post,
        updatePostUseCase: UpdatePostUseCase,
        getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase,
        getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase,
        getPostLinkedProductsUseCase: GetPostLinkedProductsUseCase
    ) {
        self.post = post
        self.description = post.description ?? ""
        self.selectedServiceDomainId = post.serviceDomain.map { String($0.id) } ?? ""
        self.updatePostUseCase = updatePostUseCase
        self.getSelectedDomainsByBusinessUseCase = getSelectedDomainsByBusinessUseCase
        self.getProductsByBusinessAndEmployeeUseCase = getProductsByBusinessAndEmployeeUseCase
        self.getPostLinkedProductsUseCase = getPostLinkedProductsUseCase
    }

    func setDescription(_ text: String) {
        let maxLength = 500
        if text.count <= maxLength {
            description = text
        }
    }

    func toggleSelectedServiceDomain(_ id: String) {
        selectedServiceDomainId = (selectedServiceDomainId == id) ? "" : id
    }

    func setLinkedProducts(_ products: [Product]) {
        linkedProducts = products
    }

    func removeLinkedProduct(_ product: Product) {
        linkedProducts.removeAll { $0.id == product.id }
    }

    func loadEditData() async {
        guard viewState == .idle else { return }
        viewState = .loading

        async let domains: () = loadServiceDomains()
        async let products: () = loadUserProducts()
        async let linked: () = loadLinkedProducts()
        _ = await (domains, products, linked)

        viewState = .success(true)
    }

    private func loadServiceDomains() async {
        do {
            let domains = try await getSelectedDomainsByBusinessUseCase(businessId: businessId)
            serviceDomainsViewState = .success(domains)
        } catch {
            serviceDomainsViewState = .error(error.localizedDescription)
        }
    }

    private func loadUserProducts() async {
        do {
            let userProducts = try await getProductsByBusinessAndEmployeeUseCase(
                businessId: businessId,
                employeeId: nil,
                onlyServicesWithProducts: false,
                productsLimitPerService: nil
            )
            userProductsViewState = .success(userProducts)
        } catch {
            userProductsViewState = .error(error.localizedDescription)
        }
    }

    private func loadLinkedProducts() async {
        do {
            linkedProducts = try await getPostLinkedProductsUseCase(postId: post.id).products
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Fetching Linked Products for Post (\(self.post.id))")
        }
    }

    func savePost() async -> Bool {
        guard !isSaving else { return false }

        isSaving = true
        errorMessage = nil
        defer { isSaving = false }

        do {
            _ = try await updatePostUseCase(
                postId: post.id,
                description: description,
                linkedProductIds: linkedProducts.map(\.id),
                serviceDomainId: Int(selectedServiceDomainId),
                customCover: nil
            )
            return true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Updating Post (\(self.post.id))")
            return false
        }
    }
}
