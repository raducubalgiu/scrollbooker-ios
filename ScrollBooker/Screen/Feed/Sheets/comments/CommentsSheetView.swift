//
//  CommentsSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct CommentsSheetView: View {
    let viewModel: CommentsViewModel
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var currentParentId: Int? = nil
    @State private var currentReplyToCommentId: Int? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                VStack(spacing: 0) {
                    VStack {
                        switch viewModel.viewState {
                        case .idle, .loading:
                            LoadingView()

                        case .error(let message):
                            ErrorView(message: message) {
                                Task { await viewModel.loadComments() }
                            }

                        case .success(let items):
                            if items.isEmpty {
                                NoDataView(
                                    title: "Comentarii",
                                    message: "Fii primul care lasă un comentariu la această postare!",
                                    systemImage: "bubble.left"
                                )
                            } else {
                                CommentsListView(
                                    items: items,
                                    viewModel: viewModel,
                                    onNavigateToUserProfile: onNavigateToUserProfile,
                                    onDismiss: { dismiss() },
                                    onPrepareReply: { parentId, replyToCommentId, username in
                                        currentParentId = parentId
                                        currentReplyToCommentId = replyToCommentId
                                        viewModel.replyingToUsername = username
                                    }
                                )
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    CommentFooterView(
                        placeholder: viewModel.inputPlaceholder,
                        replyTrigger: currentReplyToCommentId ?? currentParentId,
                        isReplyActive: currentParentId != nil,
                        onCreateComment: { text in
                            let parentIdToSend = currentParentId
                            let replyToCommentIdToSend = currentReplyToCommentId

                            Task {
                                await viewModel.sendComment(
                                    text: text,
                                    parentId: parentIdToSend,
                                    replyToCommentId: replyToCommentIdToSend
                                )
                                currentParentId = nil
                                currentReplyToCommentId = nil
                            }
                        },
                        onCancelReply: {
                            currentParentId = nil
                            currentReplyToCommentId = nil
                            viewModel.replyingToUsername = nil
                        }
                    )
                }
            }
            .navigationTitle("Comentarii")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task { await viewModel.loadComments() }
    }
}

