//
//  AccountInfoModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.10.2026.
//

import Foundation

@MainActor
final class AccountInfoModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: AccountInfoApiService = {
        AccountInfoAPIImpl(client: apiClient)
    }()

    lazy var repository: AccountInfoRepository = {
        AccountInfoRepositoryImpl(api: apiService)
    }()

    lazy var getAccountInfoUseCase: GetAccountInfoUseCase = {
        GetAccountInfoUseCase(repository: repository)
    }()

    lazy var sendPhoneVerificationCodeUseCase: SendPhoneVerificationCodeUseCase = {
        SendPhoneVerificationCodeUseCase(repository: repository)
    }()

    lazy var verifyPhoneNumberUseCase: VerifyPhoneNumberUseCase = {
        VerifyPhoneNumberUseCase(repository: repository)
    }()

    func makeAccountInfoViewModel() -> AccountInfoViewModel {
        AccountInfoViewModel(getAccountInfoUseCase: getAccountInfoUseCase)
    }

    func makePhoneVerificationViewModel() -> PhoneVerificationViewModel {
        PhoneVerificationViewModel(
            sendPhoneVerificationCodeUseCase: sendPhoneVerificationCodeUseCase,
            verifyPhoneNumberUseCase: verifyPhoneNumberUseCase
        )
    }
}
