//
//  UserProfileModule.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation

@MainActor
final class UserProfileModule {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private lazy var apiService: UserProfileApiService = {
        UserProfileApiImpl(client: apiClient)
    }()

    private lazy var repository: UserProfileRepository = {
        UserProfileRepositoryImpl(api: apiService)
    }()

    private lazy var getUserProfileUseCase: GetUserProfileUseCase = {
        GetUserProfileUseCase(repository: repository)
    }()
    
    private lazy var updateUserFullNameUseCase: UpdateUserFullNameUseCase = {
        UpdateUserFullNameUseCase(repository: repository)
    }()
    
    private lazy var updateUserGenderUseCase: UpdateUserGenderUseCase = {
        UpdateUserGenderUseCase(repository: repository)
    }()
    
    private lazy var updateUserBirthdateUseCase: UpdateUserBirthdateUseCase = {
        UpdateUserBirthdateUseCase(repository: repository)
    }()
    
    private lazy var updateUserBioUseCase: UpdateUserBioUseCase = {
        UpdateUserBioUseCase(repository: repository)
    }()
    
    func makeMyProfileViewModel(
        session: SessionManager,
        getUserPostsUseCase: GetUserPostsUseCase,
        getUserBookmarkedPostsUseCase: GetUserBookmarkedPostsUseCase
    ) -> MyProfileViewModel {
        let combinedController = ProfileController(
            getUserProfileUseCase: getUserProfileUseCase,
            getUserPostsUseCase: getUserPostsUseCase,
            getUserBookmarkedPostsUseCase: getUserBookmarkedPostsUseCase
        )
        
        return MyProfileViewModel(
            session: session,
            profileController: combinedController,
            updateUserFullNameUseCase: updateUserFullNameUseCase,
            updateUserGenderUseCase: updateUserGenderUseCase,
            updateUserBirthdateUseCase: updateUserBirthdateUseCase,
            updateUserBioUseCase: updateUserBioUseCase
        )
    }

    func makeUserProfileViewModel(
        userId: Int,
        username: String,
        getUserPostsUseCase: GetUserPostsUseCase,
        getUserBookmarkedPostsUseCase: GetUserBookmarkedPostsUseCase
    ) -> UserProfileViewModel {
        let combinedController = ProfileController(
            getUserProfileUseCase: getUserProfileUseCase,
            getUserPostsUseCase: getUserPostsUseCase,
            getUserBookmarkedPostsUseCase: getUserBookmarkedPostsUseCase
        )
        
        return UserProfileViewModel(
            userId: userId,
            username: username,
            profileController: combinedController
        )
    }
}
