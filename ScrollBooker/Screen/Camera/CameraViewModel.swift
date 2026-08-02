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
    
    private let createVideoPostUseCase: CreateVideoPostUseCase
    
    init(createVideoPostUseCase: CreateVideoPostUseCase) {
        self.createVideoPostUseCase = createVideoPostUseCase
        
        checkPhotoLibraryPermissions()
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
    
    var isSaving: Bool = false
    
    func createPost() {
        guard let selectedVideoAsset = selectedVideo else { return }
        
        isSaving = true
        
        player?.pause()
        
        Task {
            do {
                let localVideoURL = try await extractURL(from: selectedVideoAsset.asset)
                
                _ = try await createVideoPostUseCase(
                    videoURL: localVideoURL,
                    description: description,
                    linkedProductIds: [],
                    businessOrEmployeeId: nil,
                    isVideoReview: false,
                    videoReviewMessage: nil,
                    rating: nil,
                    onProgress: { _ in  }
                )
                
                isSaving = false
                
            } catch {
//                // Dacă extractURL sau UseCase-ul aruncă o eroare, o prindem direct aici
//                self.uploadStatus = .error(error.localizedDescription)
                isSaving = false
            }
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


