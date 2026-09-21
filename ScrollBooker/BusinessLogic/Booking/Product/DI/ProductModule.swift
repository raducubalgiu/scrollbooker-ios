//
//  ProductModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import Foundation

@MainActor
final class ProductModule {
    private let apiClient: APIClient
    private let userLocationService: UserLocationService

    init(apiClient: APIClient, userLocationService: UserLocationService) {
        self.apiClient = apiClient
        self.userLocationService = userLocationService
    }

    private lazy var apiService: ProductApiService = {
        ProductAPIImpl(client: apiClient)
    }()

    private lazy var repository: ProductRepository = {
        ProductRepositoryImpl(api: apiService)
    }()
    
    lazy var getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase = {
        GetProductsbyBusinessAndEmployeeUseCase(repository: repository)
    }()
    
    lazy var getPostLinkedProductsUseCase: GetPostLinkedProductsUseCase = {
        GetPostLinkedProductsUseCase(repository: repository)
    }()

    lazy var createProductUseCase: CreateProductUseCase = {
        CreateProductUseCase(repository: repository)
    }()

    lazy var getProductByIdUseCase: GetProductByIdUseCase = {
        GetProductByIdUseCase(repository: repository)
    }()

    lazy var updateProductBaseInfoUseCase: UpdateProductBaseInfoUseCase = {
        UpdateProductBaseInfoUseCase(repository: repository)
    }()

    lazy var createProductVariantUseCase: CreateProductVariantUseCase = {
        CreateProductVariantUseCase(repository: repository)
    }()

    lazy var updateProductVariantUseCase: UpdateProductVariantUseCase = {
        UpdateProductVariantUseCase(repository: repository)
    }()

    lazy var deleteProductVariantUseCase: DeleteProductVariantUseCase = {
        DeleteProductVariantUseCase(repository: repository)
    }()


    func makeMyProductsViewModel(session: SessionManager) -> MyProductsViewModel {
        MyProductsViewModel(
            session: session,
            getProductsByBusinessAndEmployeeUseCase: getProductsByBusinessAndEmployeeUseCase
        )
    }
    
    func makeLinkedProductsViewModel(
        postId: Int,
        postUserId: Int,
        isVideoReview: Bool,
        getAppointmentByUserAndPostUseCase: GetAppointmentByUserAndPostUseCase
    ) -> LinkedProductsViewModel {
        LinkedProductsViewModel(
            postId: postId,
            postUserId: postUserId,
            isVideoReview: isVideoReview,
            getPostLinkedProductsUseCase: getPostLinkedProductsUseCase,
            getAppointmentByUserAndPostUseCase: getAppointmentByUserAndPostUseCase,
            userLocationService: userLocationService
        )
    }
    
    func makeAddProductViewModel(
        session: SessionManager,
        getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        getFiltersByServiceUseCase: GetFiltersByServiceUseCase
    ) -> AddProductViewModel {
        AddProductViewModel(
            session: session,
            getSelectedDomainsByBusinessUseCase: getSelectedDomainsByBusinessUseCase,
            getEmployeesByOwnerUseCase: getEmployeesByOwnerUseCase,
            getFiltersByServiceUseCase: getFiltersByServiceUseCase,
            createProductUseCase: createProductUseCase
        )
    }

    func makeEditProductViewModel(
        productId: Int,
        session: SessionManager,
        getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        getFiltersByServiceUseCase: GetFiltersByServiceUseCase
    ) -> EditProductViewModel {
        EditProductViewModel(
            productId: productId,
            session: session,
            getSelectedDomainsByBusinessUseCase: getSelectedDomainsByBusinessUseCase,
            getEmployeesByOwnerUseCase: getEmployeesByOwnerUseCase,
            getFiltersByServiceUseCase: getFiltersByServiceUseCase,
            getProductByIdUseCase: getProductByIdUseCase,
            updateProductBaseInfoUseCase: updateProductBaseInfoUseCase,
            createProductVariantUseCase: createProductVariantUseCase,
            updateProductVariantUseCase: updateProductVariantUseCase,
            deleteProductVariantUseCase: deleteProductVariantUseCase
        )
    }
}
