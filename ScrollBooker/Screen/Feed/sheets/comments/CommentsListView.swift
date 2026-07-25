//
//  CommentsListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct CommentsListView: View {
    let comments: [Comment]
    let viewModel: CommentsViewModel
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onDismiss: () -> Void
    let onPrepareReply: (Int, Int?, String) -> Void
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                ForEach(comments, id: \.id) { comment in
                    CommentGroupRow(
                        comment: comment,
                        viewModel: viewModel,
                        onNavigateToUserProfile: onNavigateToUserProfile,
                        onDismiss: onDismiss,
                        onPrepareReply: onPrepareReply
                    )
                    .onAppear {
                        Task {
                            await viewModel.loadMoreIfNeeded(currentComment: comment)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
}
