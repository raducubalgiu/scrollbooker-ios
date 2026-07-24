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

    init(apiClient: APIClient) {
        self.apiClient = apiClient
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
    
    func makeMyProductsViewModel(session: SessionManager) -> MyProductsViewModel {
        MyProductsViewModel(
            session: session,
            getProductsByBusinessAndEmployeeUseCase: getProductsByBusinessAndEmployeeUseCase
        )
    }
    
    func makeLinkedProductsViewModel(postId: Int) -> LinkedProductsViewModel {
        LinkedProductsViewModel(
            postId: postId,
            getPostLinkedProductsUseCase: getPostLinkedProductsUseCase
        )
    }
}
