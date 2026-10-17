//
//  PublicPhoneModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

@MainActor
final class PublicPhoneModule {
    private let apiClient: APIClient
    private let sendPhoneVerificationCodeUseCase: SendPhoneVerificationCodeUseCase

    init(apiClient: APIClient, sendPhoneVerificationCodeUseCase: SendPhoneVerificationCodeUseCase) {
        self.apiClient = apiClient
        self.sendPhoneVerificationCodeUseCase = sendPhoneVerificationCodeUseCase
    }

    private lazy var apiService: PublicPhoneApiService = {
        PublicPhoneAPIImpl(client: apiClient)
    }()

    lazy var repository: PublicPhoneRepository = {
        PublicPhoneRepositoryImpl(api: apiService)
    }()

    lazy var getPublicPhoneInfoUseCase: GetPublicPhoneInfoUseCase = {
        GetPublicPhoneInfoUseCase(repository: repository)
    }()

    lazy var verifyPublicPhoneNumberUseCase: VerifyPublicPhoneNumberUseCase = {
        VerifyPublicPhoneNumberUseCase(repository: repository)
    }()

    lazy var useBusinessPublicPhoneUseCase: UseBusinessPublicPhoneUseCase = {
        UseBusinessPublicPhoneUseCase(repository: repository)
    }()

    func makePublicPhoneViewModel(session: SessionManager) -> PublicPhoneViewModel {
        PublicPhoneViewModel(
            session: session,
            getPublicPhoneInfoUseCase: getPublicPhoneInfoUseCase,
            useBusinessPublicPhoneUseCase: useBusinessPublicPhoneUseCase
        )
    }

    func makePublicPhoneVerificationViewModel() -> PublicPhoneVerificationViewModel {
        PublicPhoneVerificationViewModel(
            sendPhoneVerificationCodeUseCase: sendPhoneVerificationCodeUseCase,
            verifyPublicPhoneNumberUseCase: verifyPublicPhoneNumberUseCase
        )
    }
}
