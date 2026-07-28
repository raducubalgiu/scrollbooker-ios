//
//  CameraScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.07.2026.
//

import SwiftUI

struct CameraScreen: View {
    @Bindable var viewModel: CameraViewModel
    var onBack: () -> Void
    var onNext: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            CameraContentView(
                showSettingsCta: viewModel.showSettingsCta,
                onBack: onBack,
                openAppSettings: { viewModel.openAppSettings() }
            )
            
            CameraActionsView(
                mediaThumbnail: viewModel.mediaThumbnail,
                onMediaThumbClick: {
                    if viewModel.canOpenLibrary {
                        viewModel.isGalleryPresented = true
                    } else if viewModel.showSettingsCta {
                        viewModel.openAppSettings()
                    } else {
                        viewModel.requestMediaPermissions()
                    }
                },
                onSwitchCamera: {},
                onRecord: {}
            )
        }
        .onAppear {
            viewModel.checkPhotoLibraryPermissions()
        }
        .sheet(isPresented: $viewModel.isGalleryPresented) {
            CameraGallerySheet(
                viewModel: viewModel,
                onVideoSelected: { selectedAsset in
                    onNext()
                }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(25)
        }
    }
}


