//
//  CollectBusinessGalleryViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CollectBusinessGalleryViewModel {
    static let slotCount = 5

    private let session: SessionManager
    private let collectBusinessGalleryUseCase: CollectBusinessGalleryUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Onboarding")

    var gallerySlots: [BusinessGallerySlot] = Array(repeating: .empty, count: slotCount)
    var isSaving = false
    var saveError: String?

    var hasPhotos: Bool {
        gallerySlots.contains { $0 != .empty }
    }

    init(session: SessionManager, collectBusinessGalleryUseCase: CollectBusinessGalleryUseCase) {
        self.session = session
        self.collectBusinessGalleryUseCase = collectBusinessGalleryUseCase
    }

    func setImage(_ data: Data, at slot: Int) {
        guard gallerySlots.indices.contains(slot) else { return }
        gallerySlots[slot] = .picked(data)
    }

    func clearImage(at slot: Int) {
        guard gallerySlots.indices.contains(slot) else { return }
        gallerySlots[slot] = .empty
    }

    @discardableResult
    func collectBusinessGallery() async -> Bool {
        guard let businessId = session.userInfo?.businessId else {
            logger.error("ERROR: on Collecting Business Gallery: businessId is missing")
            saveError = String(localized: "somethingWentWrong")
            return false
        }

        isSaving = true
        saveError = nil

        let skipUpdateGallery = !hasPhotos
        let photos: [Data] = gallerySlots.compactMap {
            if case .picked(let data) = $0 { return data }
            return nil
        }

        do {
            let authState = try await withLoading {
                try await self.collectBusinessGalleryUseCase(
                    businessId: businessId,
                    photos: photos,
                    skipUpdateGallery: skipUpdateGallery
                )
            }
            session.updateAuthState(authState)
            isSaving = false
            return true
        } catch {
            saveError = logger.userMessage(for: error, context: "Collecting Business Gallery")
            isSaving = false
            return false
        }
    }
}
