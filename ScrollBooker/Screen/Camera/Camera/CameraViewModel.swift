//
//  CameraViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.07.2026.
//

import SwiftUI
import Observation
import Photos
import AVKit
import OSLog

struct LocalVideoAsset: Identifiable, Hashable {
    let id: String
    let asset: PHAsset
    var thumbnail: UIImage?
}

enum GlobalUploadStatus: Equatable {
    case idle
    case uploading
    case success
    case error(String)
}

@Observable
@MainActor
final class CameraViewModel {
    var mediaThumbnail: UIImage? = nil
    var showSettingsCta: Bool = false
    var canOpenLibrary: Bool = false
    var isGalleryPresented: Bool = false
    
    var videos: [LocalVideoAsset] = []
    
    private(set) var player: AVPlayer? = nil
    private(set) var selectedVideo: LocalVideoAsset? = nil
    private(set) var isPlayerLoading: Bool = false
    
    private var allVideoAssets: PHFetchResult<PHAsset>? = nil
    private var currentIndex = 0
    private let pageSize = 21
    
    var description: String = ""
    var uploadStatus: GlobalUploadStatus = .idle

    func setDescription(_ text: String) {
        let maxLength = 500
        if text.count <= maxLength {
            self.description = text
        }
    }

    // Set only when Camera is entered from an appointment's "leave a video review" CTA —
    // always nil for a normal post.
    let appointmentId: Int?
    let businessOrEmployeeId: Int?
    var isVideoReview: Bool { appointmentId != nil && businessOrEmployeeId != nil }

    var rating: Int = 0
    var review: String = ""

    func setRating(_ value: Int) {
        rating = value
    }

    func setReview(_ text: String) {
        let maxLength = 500
        if text.count <= maxLength {
            review = text
        }
    }

    // A video review needs a rating to be postable — matches Android's isSaveDisabled check.
    var canSubmitPost: Bool { !isSaving && (!isVideoReview || rating > 0) }

    var selectedServiceDomainId: String = ""
    private(set) var serviceDomainsViewState: FeatureState<[SelectedServiceDomainsWithServices]> = .idle

    var linkedProducts: [Product] = []
    private(set) var userProductsViewState: FeatureState<UserProducts> = .idle

    var serviceDomainOptions: [SelectOption] {
        (serviceDomainsViewState.data ?? [])
            .filter { domain in domain.services.contains { $0.isSelected } }
            .map { SelectOption(value: String($0.id), name: $0.name) }
    }

    func toggleSelectedServiceDomain(_ id: String) {
        selectedServiceDomainId = (selectedServiceDomainId == id) ? "" : id
    }

    func setLinkedProducts(_ products: [Product]) {
        linkedProducts = products
    }

    func removeLinkedProduct(_ product: Product) {
        linkedProducts.removeAll { $0.id == product.id }
    }

    // MARK: - Cover picker
    struct CoverFrame: Identifiable {
        let id = UUID()
        let timeSeconds: Double
        let image: UIImage
    }

    private(set) var coverImage: UIImage? = nil
    private(set) var isCustomCover: Bool = false
    // Dense enough (~1 frame/1.5s, capped) and generated in one batch pass so scrubbing
    // is a pure in-memory nearest-neighbor lookup — no per-frame decode while dragging,
    // which is what actually made the old "decode on every drag tick" version feel laggy/blurry.
    private(set) var filmstripFrames: [CoverFrame] = []

    private(set) var coverTimeSeconds: Double = CameraViewModel.defaultCoverTimeSeconds
    private var filmstripVideoId: String?
    private var localVideoURL: URL?
    private static let defaultCoverTimeSeconds: Double = 0.5
    private static let filmstripFrameHeight: CGFloat = 480

    private(set) var videoDurationSeconds: Double = 0

    func loadVideoDurationSeconds() async {
        guard let asset = player?.currentItem?.asset else { return }

        let duration = (try? await asset.load(.duration)) ?? .zero
        let seconds = CMTimeGetSeconds(duration)
        videoDurationSeconds = seconds.isFinite && seconds > 0 ? seconds : 0
    }

    func generateCoverIfNeeded() async {
        guard coverImage == nil, let url = await resolveLocalVideoURL() else { return }

        let generator = makeImageGenerator(for: url, maxHeight: Self.filmstripFrameHeight)
        let images = await generateFrames(
            generator: generator,
            times: [CMTime(seconds: Self.defaultCoverTimeSeconds, preferredTimescale: 600)]
        )
        if let image = images.first ?? nil {
            coverImage = image
            coverTimeSeconds = Self.defaultCoverTimeSeconds
            isCustomCover = false
        }
    }

    func ensureFilmstrip() async {
        await loadVideoDurationSeconds()
        let durationSeconds = videoDurationSeconds
        guard durationSeconds > 0 else { return }
        guard let videoId = selectedVideo?.id, filmstripVideoId != videoId else { return }
        guard let url = await resolveLocalVideoURL() else { return }

        let count = min(90, max(24, Int(durationSeconds / 0.4)))
        let interval = durationSeconds / Double(count)
        let timestamps = (0..<count).map { interval * Double($0) + interval / 2 }
        let cmTimes = timestamps.map { CMTime(seconds: $0, preferredTimescale: 600) }

        let generator = makeImageGenerator(for: url, maxHeight: Self.filmstripFrameHeight)
        let images = await generateFrames(generator: generator, times: cmTimes)

        filmstripVideoId = videoId
        filmstripFrames = zip(timestamps, images).compactMap { time, image in
            image.map { CoverFrame(timeSeconds: time, image: $0) }
        }
    }

    func nearestFilmstripFrame(to seconds: Double) -> UIImage? {
        filmstripFrames.min { abs($0.timeSeconds - seconds) < abs($1.timeSeconds - seconds) }?.image
    }

    func setCover(atSeconds seconds: Double) {
        guard let image = nearestFilmstripFrame(to: seconds) else { return }
        coverImage = image
        coverTimeSeconds = seconds
        isCustomCover = true
    }

    private func customCoverDataURI() -> String? {
        guard isCustomCover, let coverImage else { return nil }
        return CoverImageEncoding.toCoverDataURI(coverImage)
    }

    private func resolveLocalVideoURL() async -> URL? {
        if let localVideoURL { return localVideoURL }
        guard let selectedVideo else { return nil }

        let url = try? await extractURL(from: selectedVideo.asset)
        localVideoURL = url
        return url
    }

    private func makeImageGenerator(for url: URL, maxHeight: CGFloat) -> AVAssetImageGenerator {
        let generator = AVAssetImageGenerator(asset: AVURLAsset(url: url))
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: .greatestFiniteMagnitude, height: maxHeight)
        return generator
    }

    // A single decoder session reused across every requested time — far cheaper than
    // calling copyCGImage/image(at:) N separate times.
    private func generateFrames(generator: AVAssetImageGenerator, times: [CMTime]) async -> [UIImage?] {
        await withCheckedContinuation { continuation in
            var results = [UIImage?](repeating: nil, count: times.count)
            let group = DispatchGroup()
            times.forEach { _ in group.enter() }

            let nsTimes = times.map { NSValue(time: $0) }
            generator.generateCGImagesAsynchronously(forTimes: nsTimes) { requestedTime, cgImage, _, result, _ in
                defer { group.leave() }
                guard result == .succeeded, let cgImage else { return }
                if let index = times.firstIndex(of: requestedTime) {
                    results[index] = UIImage(cgImage: cgImage)
                }
            }

            group.notify(queue: .main) {
                continuation.resume(returning: results)
            }
        }
    }

    func loadPostComposerData() async {
        // A video review is posted by the customer, who has no catalog to link — and
        // even a customer who also happens to own a business shouldn't see it here,
        // since CreatePostScreen hides those sections entirely for a video review.
        guard !isVideoReview, let businessId = session.userInfo?.businessId else { return }

        async let domains: () = loadServiceDomains(businessId: businessId)
        async let products: () = loadUserProducts(businessId: businessId)
        _ = await (domains, products)
    }

    private func loadServiceDomains(businessId: Int) async {
        guard serviceDomainsViewState == .idle else { return }
        serviceDomainsViewState = .loading

        do {
            let domains = try await getSelectedDomainsByBusinessUseCase(businessId: businessId)
            serviceDomainsViewState = .success(domains)
        } catch {
            serviceDomainsViewState = .error(error.localizedDescription)
        }
    }

    private func loadUserProducts(businessId: Int) async {
        guard userProductsViewState == .idle else { return }
        userProductsViewState = .loading

        do {
            let userProducts = try await getProductsByBusinessAndEmployeeUseCase(
                businessId: businessId,
                employeeId: nil,
                onlyServicesWithProducts: false,
                productsLimitPerService: nil
            )
            userProductsViewState = .success(userProducts)
        } catch {
            userProductsViewState = .error(error.localizedDescription)
        }
    }

    private let session: SessionManager
    private let createVideoPostUseCase: CreateVideoPostUseCase
    private let createVideoReviewUseCase: CreateVideoReviewUseCase
    private let getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase
    private let getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Camera")

    init(
        session: SessionManager,
        appointmentId: Int?,
        businessOrEmployeeId: Int?,
        createVideoPostUseCase: CreateVideoPostUseCase,
        createVideoReviewUseCase: CreateVideoReviewUseCase,
        getSelectedDomainsByBusinessUseCase: GetSelectedDomainsByBusinesssUseCase,
        getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase
    ) {
        self.session = session
        self.appointmentId = appointmentId
        self.businessOrEmployeeId = businessOrEmployeeId
        self.createVideoPostUseCase = createVideoPostUseCase
        self.createVideoReviewUseCase = createVideoReviewUseCase
        self.getSelectedDomainsByBusinessUseCase = getSelectedDomainsByBusinessUseCase
        self.getProductsByBusinessAndEmployeeUseCase = getProductsByBusinessAndEmployeeUseCase
        // Not called here — its synchronous Photos I/O would block init; CameraScreen.onAppear calls it once mounted.
    }
    
    func checkPhotoLibraryPermissions() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            self.canOpenLibrary = true
            self.showSettingsCta = false
            self.fetchLastVideoThumbnail()
            self.prepareGalleryFetch()
        case .denied, .restricted:
            self.canOpenLibrary = false
            self.showSettingsCta = true
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func requestMediaPermissions() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            guard let self else { return }
            Task { @MainActor in
                if status == .authorized || status == .limited {
                    self.canOpenLibrary = true
                    self.showSettingsCta = false
                    self.fetchLastVideoThumbnail()
                    self.prepareGalleryFetch()
                    self.isGalleryPresented = true
                } else {
                    self.canOpenLibrary = false
                    self.showSettingsCta = true
                }
            }
        }
    }
    
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    func preparePreviewForSelectedVideo() {
        guard let videoAsset = selectedVideo else { return }
        
        player?.pause()
        player = nil
        isPlayerLoading = true
        
        let options = PHVideoRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestAVAsset(forVideo: videoAsset.asset, options: options) { [weak self] avAsset, _, _ in
            guard let self else { return }
            Task { @MainActor in
                guard self.selectedVideo?.id == videoAsset.id else { return }
                
                if let urlAsset = avAsset as? AVURLAsset {
                    let newPlayer = AVPlayer(url: urlAsset.url)
                    
                    NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: newPlayer.currentItem,
                        queue: .main
                    ) { _ in
                        newPlayer.seek(to: .zero)
                        newPlayer.play()
                    }
                    
                    self.player = newPlayer
                    self.isPlayerLoading = false
                    newPlayer.play()
                    Task { await self.loadVideoDurationSeconds() }
                } else {
                    self.isPlayerLoading = false
                }
            }
        }
    }

    func clearActivePlayer() {
        player?.pause()
        player = nil
        selectedVideo = nil
        isPlayerLoading = false
    }
    
    func setSelectedVideo(_ video: LocalVideoAsset) {
        if selectedVideo?.id != video.id {
            player?.pause()
            player = nil
            isPlayerLoading = false

            localVideoURL = nil
            coverImage = nil
            isCustomCover = false
            filmstripFrames = []
            filmstripVideoId = nil
            coverTimeSeconds = Self.defaultCoverTimeSeconds
            videoDurationSeconds = 0
        }

        self.selectedVideo = video
    }

    func resumeOrCreatePreview() {
        if let player = self.player {
            player.play()
            return
        }
        
        guard let videoAsset = selectedVideo else { return }
        
        isPlayerLoading = true
        
        let options = PHVideoRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestAVAsset(forVideo: videoAsset.asset, options: options) { [weak self] avAsset, _, _ in
            guard let self else { return }
            Task { @MainActor in
                guard self.selectedVideo?.id == videoAsset.id else { return }
                
                if let urlAsset = avAsset as? AVURLAsset {
                    let newPlayer = AVPlayer(url: urlAsset.url)
                    
                    NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: newPlayer.currentItem,
                        queue: .main
                    ) { _ in
                        newPlayer.seek(to: .zero)
                        newPlayer.play()
                    }
                    
                    self.player = newPlayer
                    self.isPlayerLoading = false
                    newPlayer.play()
                    Task { await self.loadVideoDurationSeconds() }
                } else {
                    self.isPlayerLoading = false
                }
            }
        }
    }

    func pauseActivePlayer() {
        player?.pause()
    }

    private func fetchLastVideoThumbnail() {
        Task.detached(priority: .userInitiated) {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.fetchLimit = 1
            let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
            
            guard let lastVideoAsset = fetchResult.firstObject else { return }
            
            PHImageManager.default().requestImage(
                for: lastVideoAsset,
                targetSize: CGSize(width: 100, height: 100),
                contentMode: .aspectFill,
                options: nil
            ) { image, _ in
                if let grabbedImage = image {
                    Task { @MainActor in self.mediaThumbnail = grabbedImage }
                }
            }
        }
    }
    
    private func prepareGalleryFetch() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.allVideoAssets = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        self.videos = []
        self.currentIndex = 0
        
        loadMoreVideos()
    }
    
    func loadMoreVideos() {
        guard let allAssets = allVideoAssets, currentIndex < allAssets.count else { return }
        
        let nextIndex = min(currentIndex + pageSize, allAssets.count)
        var newBatch: [LocalVideoAsset] = []
        
        for i in currentIndex..<nextIndex {
            let asset = allAssets.object(at: i)
            let localAsset = LocalVideoAsset(id: asset.localIdentifier, asset: asset, thumbnail: nil)
            newBatch.append(localAsset)
        }
        
        let startIndex = currentIndex
        self.videos.append(contentsOf: newBatch)
        self.currentIndex = nextIndex
        
        for i in startIndex..<nextIndex {
            let currentAsset = self.videos[i].asset
            let targetIndex = i
            
            PHImageManager.default().requestImage(
                for: currentAsset,
                targetSize: CGSize(width: 200, height: 200),
                contentMode: .aspectFill,
                options: nil
            ) { [weak self] image, _ in
                guard let self, let grabbedImage = image else { return }
                if targetIndex < self.videos.count && self.videos[targetIndex].id == currentAsset.localIdentifier {
                    self.videos[targetIndex].thumbnail = grabbedImage
                }
            }
        }
    }
    
    func loadMoreVideosIfNeeded(currentVideo: LocalVideoAsset) {
        guard let lastIndex = videos.firstIndex(where: { $0.id == currentVideo.id }),
              lastIndex >= videos.count - 6 else { return }
        loadMoreVideos()
    }
    
    private(set) var isSaving: Bool = false
    var errorMessage: String?

    func createPost() async -> Bool {
        guard let selectedVideoAsset = selectedVideo else { return false }
        guard canSubmitPost else { return false }

        isSaving = true
        errorMessage = nil
        player?.pause()
        defer { isSaving = false }

        do {
            let localVideoURL = try await extractURL(from: selectedVideoAsset.asset)

            if isVideoReview, let appointmentId, let businessOrEmployeeId {
                _ = try await createVideoReviewUseCase(
                    videoURL: localVideoURL,
                    appointmentId: appointmentId,
                    businessOrEmployeeId: businessOrEmployeeId,
                    rating: rating,
                    review: review.isEmpty ? nil : review,
                    description: description,
                    customCover: customCoverDataURI(),
                    onProgress: { _ in }
                )
            } else {
                _ = try await createVideoPostUseCase(
                    videoURL: localVideoURL,
                    description: description,
                    linkedProductIds: linkedProducts.map(\.id),
                    serviceDomainId: Int(selectedServiceDomainId),
                    customCover: customCoverDataURI(),
                    onProgress: { _ in }
                )
            }

            return true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Creating Post")
            return false
        }
    }
    
    private func extractURL(from asset: PHAsset) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, info in
                if let urlAsset = avAsset as? AVURLAsset {
                    continuation.resume(returning: urlAsset.url)
                } else if let sandboxError = info?[PHImageErrorKey] as? Error {
                    continuation.resume(throwing: sandboxError)
                } else {
                    continuation.resume(
                        throwing: NSError(
                            domain: "CameraViewModel",
                            code: 404,
                            userInfo: [NSLocalizedDescriptionKey: "Nu s-a putut genera adresa locală a fișierului video."]
                        )
                    )
                }
            }
        }
    }
}


