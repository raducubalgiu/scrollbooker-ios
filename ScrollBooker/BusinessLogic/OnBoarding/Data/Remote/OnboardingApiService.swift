//
//  OnboardingApiService.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

protocol OnboardingApiService: Sendable {
    func collectUserUsername(request: UpdateUsernameRequest) async throws -> AuthStateDTO
    func collectBusiness(request: BusinessCreateRequestDTO) async throws -> BusinessCreateResponseDTO
    func collectBusinessGallery(businessId: Int, photos: [Data], skipUpdateGallery: Bool) async throws -> AuthStateDTO
    func collectBusinessServices(request: ServiceIdsUpdateRequestDTO) async throws -> AuthStateDTO
    func collectBusinessSchedules(schedules: [ScheduleDto]) async throws -> AuthStateDTO
}

final class OnboardingAPIImpl: OnboardingApiService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func collectUserUsername(request: UpdateUsernameRequest) async throws -> AuthStateDTO {
        try await client.request(
            "onboarding/collect-user-username",
            method: .patch,
            body: request
        )
    }

    func collectBusiness(request: BusinessCreateRequestDTO) async throws -> BusinessCreateResponseDTO {
        try await client.request(
            "onboarding/collect-business",
            method: .post,
            body: request
        )
    }

    func collectBusinessGallery(businessId: Int, photos: [Data], skipUpdateGallery: Bool) async throws -> AuthStateDTO {
        return try await client.multiPartRequest(
            "onboarding/collect-business-gallery/\(businessId)/update",
            method: .patch,
            query: ["skip_update_gallery": skipUpdateGallery ? "true" : "false"],
            fields: [:],
            files: MultipartFile.compressedJPEGs(photos)
        )
    }

    func collectBusinessServices(request: ServiceIdsUpdateRequestDTO) async throws -> AuthStateDTO {
        try await client.request(
            "onboarding/collect-business-services",
            method: .patch,
            body: request
        )
    }

    func collectBusinessSchedules(schedules: [ScheduleDto]) async throws -> AuthStateDTO {
        try await client.request(
            "onboarding/collect-business-schedules",
            method: .patch,
            body: schedules
        )
    }
}
