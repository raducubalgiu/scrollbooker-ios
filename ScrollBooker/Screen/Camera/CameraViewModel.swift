//
//  CameraViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.07.2026.
//

import SwiftUI
import Observation
import Photos

struct LocalVideoAsset: Identifiable, Hashable {
    let id: String
    let asset: PHAsset
    var thumbnail: UIImage?
}

@Observable
@MainActor
final class CameraViewModel {
    var mediaThumbnail: UIImage? = nil
    var showSettingsCta: Bool = false
    var canOpenLibrary: Bool = false
    var isGalleryPresented: Bool = false
    
    var videos: [LocalVideoAsset] = []
    private var allVideoAssets: PHFetchResult<PHAsset>? = nil
    private var currentIndex = 0
    private let pageSize = 21
    
    init() {
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
            PHImageManager.default().requestImage(
                for: currentAsset,
                targetSize: CGSize(width: 200, height: 200),
                contentMode: .aspectFill,
                options: nil
            ) { [weak self] image, _ in
                guard let self, let grabbedImage = image else { return }
                if let index = self.videos.firstIndex(where: { $0.id == currentAsset.localIdentifier }) {
                    self.videos[index].thumbnail = grabbedImage
                }
            }
        }
    }
    
    func loadMoreVideosIfNeeded(currentVideo: LocalVideoAsset) {
        guard let lastIndex = videos.firstIndex(where: { $0.id == currentVideo.id }),
              lastIndex >= videos.count - 6 else { return }
        loadMoreVideos()
    }
}

