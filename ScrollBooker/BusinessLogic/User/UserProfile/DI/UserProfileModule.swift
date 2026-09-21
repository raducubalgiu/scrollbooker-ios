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
    private let userLocationService: UserLocationService

    init(apiClient: APIClient, userLocationService: UserLocationService) {
        self.apiClient = apiClient
        self.userLocationService = userLocationService
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
    
    private lazy var getUserProfileAboutUseCase: GetUserProfileAboutUseCase = {
        GetUserProfileAboutUseCase(repository: repository)
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

    private lazy var updateUserAvatarUseCase: UpdateUserAvatarUseCase = {
        UpdateUserAvatarUseCase(repository: repository)
    }()

    lazy var searchUsernameUseCase: SearchUsernameUseCase = {
        SearchUsernameUseCase(repository: repository)
    }()

    func makeMyProfileViewModel(
        session: SessionManager,
        getUserPostsUseCase: GetUserPostsUseCase,
        getUserBookmarkedPostsUseCase: GetUserBookmarkedPostsUseCase,
        getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase,
    ) -> MyProfileViewModel {
        let combinedController = ProfileController(
            getUserProfileUseCase: getUserProfileUseCase,
            getUserProfileAboutUseCase: getUserProfileAboutUseCase,
            getUserPostsUseCase: getUserPostsUseCase,
            getUserBookmarkedPostsUseCase: getUserBookmarkedPostsUseCase,
            getProductsByBusinessAndEmployeeUseCase: getProductsByBusinessAndEmployeeUseCase,
            getEmployeesByOwnerUseCase: getEmployeesByOwnerUseCase,
            getSchedulesByUserIdUseCase: getSchedulesByUserIdUseCase,
            userLocationService: userLocationService
        )

        return MyProfileViewModel(
            session: session,
            profileController: combinedController,
            updateUserFullNameUseCase: updateUserFullNameUseCase,
            updateUserGenderUseCase: updateUserGenderUseCase,
            updateUserBirthdateUseCase: updateUserBirthdateUseCase,
            updateUserBioUseCase: updateUserBioUseCase,
            updateUserAvatarUseCase: updateUserAvatarUseCase
        )
    }

    func makeUserProfileViewModel(
        userId: Int,
        username: String,
        getUserPostsUseCase: GetUserPostsUseCase,
        getUserBookmarkedPostsUseCase: GetUserBookmarkedPostsUseCase,
        getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase,
        getEmployeesByOwnerUseCase: GetEmployeesByOwnerUseCase,
        getSchedulesByUserIdUseCase: GetSchedulesByUserIdUseCase,
        followUserUseCase: FollowUserUseCase,
        unfollowUserUseCase: UnfollowUserUseCase,
    ) -> UserProfileViewModel {
        let combinedController = ProfileController(
            getUserProfileUseCase: getUserProfileUseCase,
            getUserProfileAboutUseCase: getUserProfileAboutUseCase,
            getUserPostsUseCase: getUserPostsUseCase,
            getUserBookmarkedPostsUseCase: getUserBookmarkedPostsUseCase,
            getProductsByBusinessAndEmployeeUseCase: getProductsByBusinessAndEmployeeUseCase,
            getEmployeesByOwnerUseCase: getEmployeesByOwnerUseCase,
            getSchedulesByUserIdUseCase: getSchedulesByUserIdUseCase,
            userLocationService: userLocationService
        )

        return UserProfileViewModel(
            userId: userId,
            username: username,
            profileController: combinedController,
            followUserUseCase: followUserUseCase,
            unfollowUserUseCase: unfollowUserUseCase
        )
    }
}
