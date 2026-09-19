//
//  CameraFlowContainer.swift
//  ScrollBooker
//

import SwiftUI

struct CameraFlowContainer: View {
    let container: AppContainer
    let session: SessionManager
    let params: CameraParams
    var onPostCreated: () -> Void
    var onNavigateToEditProduct: (Int) -> Void
    var onBack: () -> Void

    @State private var viewModel: CameraViewModel
    @State private var composerSteps: [CameraFlowStep] = [.gallery]

    init(
        container: AppContainer,
        session: SessionManager,
        params: CameraParams,
        onPostCreated: @escaping () -> Void,
        onNavigateToEditProduct: @escaping (Int) -> Void,
        onBack: @escaping () -> Void
    ) {
        self.container = container
        self.session = session
        self.params = params
        self.onPostCreated = onPostCreated
        self.onNavigateToEditProduct = onNavigateToEditProduct
        self.onBack = onBack
        _viewModel = State(initialValue: container.postModule.makeCameraViewModel(
            session: session,
            appointmentId: params.appointmentId,
            businessOrEmployeeId: params.businessOrEmployeeId,
            cloudflareRepository: container.cloudflareModuke.repository,
            getSelectedDomainsByBusinessUseCase: container.servieDomainModule.getSelectedDomainsByBusinessUseCase,
            getProductsByBusinessAndEmployeeUseCase: container.productModule.getProductsByBusinessAndEmployeeUseCase
        ))
    }

    private func push(_ step: CameraFlowStep) {
        composerSteps.append(step)
    }

    private func back() {
        if composerSteps.count > 1 {
            composerSteps.removeLast()
        } else {
            viewModel.isGalleryPresented = false
        }
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        CameraScreen(viewModel: viewModel, onBack: onBack)
            .fullScreenCover(
                isPresented: $viewModel.isGalleryPresented,
                onDismiss: { composerSteps = [.gallery] }
            ) {
                ZStack {
                    ForEach(Array(composerSteps.enumerated()), id: \.element) { index, step in
                        let isTop = index == composerSteps.count - 1

                        composerStepView(for: step, isTop: isTop)
                            .zIndex(Double(index))
                            .opacity(isTop ? 1 : 0)
                            .allowsHitTesting(isTop)
                    }
                }
            }
    }

    @ViewBuilder
    private func composerStepView(for step: CameraFlowStep, isTop: Bool) -> some View {
        switch step {
        case .gallery:
            CameraGallerySheet(
                viewModel: viewModel,
                onVideoSelected: { asset in
                    viewModel.setSelectedVideo(asset)
                    push(.preview)
                }
            )

        case .preview:
            CameraPreviewScreen(
                viewModel: viewModel,
                isActive: isTop,
                onBack: back,
                onNext: { push(.createPost) }
            )

        case .createPost:
            CreatePostScreen(
                viewModel: viewModel,
                onBack: back,
                onPostCreated: {
                    viewModel.isGalleryPresented = false
                    onPostCreated()
                },
                onNavigateToPreview: { push(.createPostPreview) },
                onNavigateToCover: { push(.createPostCover) },
                onNavigateToEditProduct: onNavigateToEditProduct
            )

        case .createPostPreview:
            CreatePostPreviewScreen(viewModel: viewModel, isActive: isTop, onBack: back)

        case .createPostCover:
            CreatePostCoverScreen(viewModel: viewModel, onBack: back)
        }
    }
}
