//
//  MyBusinessDetailsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class MyBusinessDetailsViewModel {
    static let slotCount = 5

    private let session: SessionManager
    private let toastCenter: ToastCenter
    private let getMyBusinessDetailsUseCase: GetMyBusinessDetailsUseCase
    private let updateBusinessGalleryUseCase: UpdateBusinessGalleryUseCase
    private let updateSchedulesUseCase: UpdateSchedulesUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "MyBusiness")

    private(set) var businessDetailsState: FeatureState<BusinessDetails> = .idle
    private(set) var schedulesState: FeatureState<[Schedule]> = .idle

    var gallerySlots: [BusinessGallerySlot] = Array(repeating: .empty, count: slotCount)
    private var initialGallerySlots: [BusinessGallerySlot] = Array(repeating: .empty, count: slotCount)
    var isSavingGallery = false
    var galleryError: String?

    var isSavingSchedules = false

    var hasPhotos: Bool {
        gallerySlots.contains { $0 != .empty }
    }

    var hasGalleryChanges: Bool {
        gallerySlots != initialGallerySlots
    }

    init(
        session: SessionManager,
        toastCenter: ToastCenter,
        getMyBusinessDetailsUseCase: GetMyBusinessDetailsUseCase,
        updateBusinessGalleryUseCase: UpdateBusinessGalleryUseCase,
        updateSchedulesUseCase: UpdateSchedulesUseCase
    ) {
        self.session = session
        self.toastCenter = toastCenter
        self.getMyBusinessDetailsUseCase = getMyBusinessDetailsUseCase
        self.updateBusinessGalleryUseCase = updateBusinessGalleryUseCase
        self.updateSchedulesUseCase = updateSchedulesUseCase
    }

    func loadBusinessDetails() async {
        guard businessDetailsState.data == nil else { return }
        guard businessDetailsState != .loading else { return }

        businessDetailsState = .loading

        do {
            let details = try await withLoading {
                try await self.getMyBusinessDetailsUseCase()
            }
            businessDetailsState = .success(details)
            schedulesState = .success(details.schedules)

            let sortedMedia = details.mediaFiles.sorted { $0.orderIndex < $1.orderIndex }
            var slots = Array(repeating: BusinessGallerySlot.empty, count: Self.slotCount)
            for (index, media) in sortedMedia.prefix(Self.slotCount).enumerated() {
                if let url = media.mediaURL {
                    slots[index] = .existing(url)
                }
            }
            gallerySlots = slots
            initialGallerySlots = slots
        } catch {
            businessDetailsState = .error(logger.userMessage(for: error, context: "Loading Business Details"))
        }
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
    func saveGallery() async -> Bool {
        guard let businessId = session.userInfo?.businessId else {
            logger.error("ERROR: on Updating Business Gallery: businessId is missing")
            galleryError = String(localized: "message_error_something_went_wrong")
            return false
        }

        isSavingGallery = true
        galleryError = nil

        do {
            let photos = try await resolvePhotosData()

            _ = try await withLoading {
                try await self.updateBusinessGalleryUseCase(businessId: businessId, photos: photos)
            }

            initialGallerySlots = gallerySlots
            isSavingGallery = false
            toastCenter.show(String(localized: "businessGalleryUpdatedSuccessfully"))
            return true
        } catch {
            galleryError = logger.userMessage(for: error, context: "Updating Business Gallery")
            isSavingGallery = false
            toastCenter.show(String(localized: "message_error_something_went_wrong"), type: .error)
            return false
        }
    }

    private func resolvePhotosData() async throws -> [Data] {
        var photos: [Data] = []

        for slot in gallerySlots {
            switch slot {
            case .empty:
                continue
            case .picked(let data):
                photos.append(data)
            case .existing(let url):
                let (data, _) = try await URLSession.shared.data(from: url)
                photos.append(data)
            }
        }

        return photos
    }

    func updateLocalScheduleRow(_ updatedSchedule: Schedule) {
        guard var currentSchedules = schedulesState.data else { return }

        if let index = currentSchedules.firstIndex(where: { $0.id == updatedSchedule.id }) {
            currentSchedules[index] = updatedSchedule
            schedulesState = .success(currentSchedules)
        }
    }

    func saveSchedules() async {
        guard let currentSchedules = schedulesState.data else { return }
        guard !isSavingSchedules else { return }

        isSavingSchedules = true

        do {
            let updated = try await withLoading {
                try await self.updateSchedulesUseCase(schedules: currentSchedules)
            }
            schedulesState = .success(updated)
            toastCenter.show(String(localized: "scheduleSaved"))
        } catch {
            logger.error("ERROR: on Saving Business Schedules: \(error.localizedDescription, privacy: .public)")
            toastCenter.show(String(localized: "message_error_something_went_wrong"), type: .error)
        }

        isSavingSchedules = false
    }
}
