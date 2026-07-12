//
//  ProfileViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//


import Foundation
import Observation

@Observable
@MainActor
final class MyProfileViewModel: HasLoadingState {
    let profileController: ProfileController
    private let session: SessionManager
    
    var isSaved = false
    
    var isLoading: Bool {
        get { profileController.isLoading }
        set { profileController.isLoading = newValue }
    }

    var errorMessage: String? {
        get { profileController.errorMessage }
        set { profileController.errorMessage = newValue }
    }
    
    let updateUserFullNameUseCase: UpdateUserFullNameUseCase
    let updateUserGenderUseCase: UpdateUserGenderUseCase
    
    init(
        session: SessionManager,
        profileController: ProfileController,
        updateUserFullNameUseCase: UpdateUserFullNameUseCase,
        updateUserGenderUseCase: UpdateUserGenderUseCase
    ) {
        self.session = session
        self.profileController = profileController
        self.updateUserFullNameUseCase = updateUserFullNameUseCase
        self.updateUserGenderUseCase = updateUserGenderUseCase
    }
    
    func loadProfile() async {
        guard let username = session.userInfo?.username else {
            profileController.uiState.errorMessage = "Username not found"
            return
        }
        await profileController.fetchProfile(username: username)
    }
    
    func refresh() async {
        guard let username = session.userInfo?.username else { return }
        await profileController.refreshProfile(username: username)
    }
    
    func updateFullName(fullname: String) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await withVisibleLoading {
                try await updateUserFullNameUseCase(fullname: fullname)
            }
            
            if let currentProfile = profileController.uiState.data {
                profileController.uiState.data = currentProfile.copy(fullName: result.fullName)
            }
            
            isSaved = true
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
        
        isLoading = false
    }
    
    func updateGender(genderEnum: GenderTypeEnum) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await withVisibleLoading {
                try await updateUserGenderUseCase(gender: genderEnum.rawValue)
            }
            
            if let currentProfile = profileController.uiState.data {
                profileController.uiState.data = currentProfile.copy(gender: result.gender)
            }
            
            isSaved = true
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
        
        isLoading = false
    }
    
    func updateBio(newBio: String) async {
        // Logica de editare bio...
    }
}
