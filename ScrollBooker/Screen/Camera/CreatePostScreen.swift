//
//  CreatePostScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.07.2026.
//

import SwiftUI

struct CreatePostScreen: View {
    @Bindable var viewModel: CameraViewModel
    var onBack: () -> Void
    var onNavigateToPostPreview: () -> Void
    
    @State private var showErrorAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: String(localized: "createPostTitle"),
                onBack: onBack
            )
            
            ScrollView {
                VStack(spacing: 0) {
                    CreatePostHeaderView(
                        viewModel: viewModel,
                        onNavigateToPostPreview: onNavigateToPostPreview
                    )
                }
                .padding(.top, 16)
            }
//            .onTapGesture {
//                UIApplication.shared.endEditing()
//            }
        }
        .navigationBarHidden(true)
        .background(Color.backgroundSB)
        .safeAreaInset(edge: .bottom) {
            MainButton(
                title: "Creeaza",
                isDisabled: viewModel.isSaving,
                isLoading: viewModel.isSaving,
                onClick: { viewModel.createPost() },
            )
            .padding(.horizontal)
        }
//        .onChange(of: viewModel.uploadStatus) { _, newStatus in
//            switch newStatus {
//            case .uploading:
//                onBack()
//            case .error(let message):
//                self.alertMessage = message
//                self.showErrorAlert = true
//            case .success, .idle:
//                break
//            }
//        }
//        .alert("Error starting post", isPresented: $showErrorAlert) {
//            Button("OK", role: .cancel) {
//                viewModel.resetUploadStatus()
//            }
//        } message: {
//            Text(alertMessage)
//        }
    }
}
