//
//  ProfileViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//


import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class MyProfileViewModel {
    let profileController: ProfileController
    private let session: SessionManager
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "MyProfile")

    var isSaved = false
    var isLoading: Bool = false
    var errorMessage: String?

    var selectedTab: ProfileTab = .posts {
        didSet {
            guard oldValue != selectedTab else { return }
            guard let userId = session.userInfo?.id else { return }

            Task {
                await profileController.loadTabContentIfNeeded(selectedTab, userId: userId)
            }
        }
    }

    var selectedBirthdate: Date = Date()

    let updateUserFullNameUseCase: UpdateUserFullNameUseCase
    let updateUserGenderUseCase: UpdateUserGenderUseCase
    let updateUserBirthdateUseCase: UpdateUserBirthdateUseCase
    let updateUserBioUseCase: UpdateUserBioUseCase

    init(
        session: SessionManager,
        profileController: ProfileController,
        updateUserFullNameUseCase: UpdateUserFullNameUseCase,
        updateUserGenderUseCase: UpdateUserGenderUseCase,
        updateUserBirthdateUseCase: UpdateUserBirthdateUseCase,
        updateUserBioUseCase: UpdateUserBioUseCase
    ) {
        self.session = session
        self.profileController = profileController
        self.updateUserFullNameUseCase = updateUserFullNameUseCase
        self.updateUserGenderUseCase = updateUserGenderUseCase
        self.updateUserBirthdateUseCase = updateUserBirthdateUseCase
        self.updateUserBioUseCase = updateUserBioUseCase
    }

    func loadProfile() async {
        guard let userId = session.userInfo?.id else { return }
        guard let username = session.userInfo?.username else { return }

        await profileController.fetchProfile(username: username)
        await profileController.loadTabContentIfNeeded(selectedTab, userId: userId)
    }

    func refresh() async {
        guard let userId = session.userInfo?.id else { return }
        guard let username = session.userInfo?.username else { return }

        await profileController.refresh(
            username: username,
            userId: userId,
            activeTab: selectedTab
        )
    }

    func updateFullName(fullname: String) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await withLoading {
                try await updateUserFullNameUseCase(fullname: fullname)
            }

            if let currentProfile = profileController.profile {
                profileController.updateProfile(currentProfile.copy(fullName: result.fullName))
            }

            isSaved = true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Updating Full Name")
        }

        isLoading = false
    }

    func updateBirthDate() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let birthDateString = formatter.string(from: selectedBirthdate)

        do {
            _ = try await withLoading {
                try await updateUserBirthdateUseCase(birthdate: birthDateString)
            }

            if let currentProfile = profileController.profile {
                profileController.updateProfile(currentProfile.copy(dateOfBirth: birthDateString))
            }
            isSaved = true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Updating Birth Date")
        }
        isLoading = false
    }

    func updateGender(genderEnum: GenderTypeEnum) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await withLoading {
                try await updateUserGenderUseCase(gender: genderEnum.rawValue)
            }

            if let currentProfile = profileController.profile {
                profileController.updateProfile(currentProfile.copy(gender: result.gender))
            }

            isSaved = true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Updating Gender")
        }

        isLoading = false
    }

    func updateBio(bio: String) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await withLoading {
                try await updateUserBioUseCase(bio: bio)
            }

            if let currentProfile = profileController.profile {
                profileController.updateProfile(currentProfile.copy(bio: result.bio))
            }

            isSaved = true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Updating Bio")
        }

        isLoading = false
    }
}
