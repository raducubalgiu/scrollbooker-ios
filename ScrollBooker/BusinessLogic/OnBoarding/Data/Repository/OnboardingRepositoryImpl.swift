//
//  OnboardingRepositoryImpl.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

final class OnboardingRepositoryImpl: OnboardingRepository {
    private let api: OnboardingApiService

    init(api: OnboardingApiService) {
        self.api = api
    }

    func collectUserUsername(username: String) async throws -> AuthState {
        let dto = try await api.collectUserUsername(request: UpdateUsernameRequest(username: username))
        return AuthState(dto: dto)
    }

    func collectClientBirthdate(birthdate: String?) async throws -> AuthState {
        let dto = try await api.collectClientBirthdate(request: UpdateBirthDateRequest(birthdate: birthdate))
        return AuthState(dto: dto)
    }

    func collectClientGender(gender: String) async throws -> AuthState {
        let dto = try await api.collectClientGender(request: UpdateGenderRequest(gender: gender))
        return AuthState(dto: dto)
    }

    func collectClientLocationPermission() async throws -> AuthState {
        let dto = try await api.collectClientLocationPermission()
        return AuthState(dto: dto)
    }

    func collectBusiness(
        description: String?,
        placeId: String,
        businessTypeId: Int,
        ownerFullName: String
    ) async throws -> BusinessCreateResponse {
        let request = BusinessCreateRequestDTO(
            description: description,
            placeId: placeId,
            businessTypeId: businessTypeId,
            ownerFullName: ownerFullName
        )
        let dto = try await api.collectBusiness(request: request)
        return BusinessCreateResponse(dto: dto)
    }

    func collectBusinessGallery(businessId: Int, photos: [Data], skipUpdateGallery: Bool) async throws -> AuthState {
        let dto = try await api.collectBusinessGallery(
            businessId: businessId,
            photos: photos,
            skipUpdateGallery: skipUpdateGallery
        )
        return AuthState(dto: dto)
    }

    func collectBusinessServices(serviceIds: [Int]) async throws -> AuthState {
        let dto = try await api.collectBusinessServices(request: ServiceIdsUpdateRequestDTO(serviceIds: serviceIds))
        return AuthState(dto: dto)
    }

    func collectBusinessSchedules(schedules: [Schedule]) async throws -> AuthState {
        let dto = try await api.collectBusinessSchedules(schedules: schedules.toDto())
        return AuthState(dto: dto)
    }

    func collectBusinessHasEmployees(hasEmployees: Bool) async throws -> AuthState {
        let dto = try await api.collectBusinessHasEmployees(
            request: BusinessHasEmployeesUpdateRequestDTO(hasEmployees: hasEmployees)
        )
        return AuthState(dto: dto)
    }
}
