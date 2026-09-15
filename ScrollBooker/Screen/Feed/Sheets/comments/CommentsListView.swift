//
//  CommentsListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct CommentsListView: View {
    let items: [CommentUIItem]
    let viewModel: CommentsViewModel
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onDismiss: () -> Void
    let onPrepareReply: (Int, Int?, String) -> Void

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                ForEach(items, id: \.id) { item in
                    CommentGroupRow(
                        item: item,
                        viewModel: viewModel,
                        onNavigateToUserProfile: onNavigateToUserProfile,
                        onDismiss: onDismiss,
                        onPrepareReply: onPrepareReply
                    )
                    .equatable()
                    .onAppear {
                        Task {
                            await viewModel.loadMoreIfNeeded(currentItem: item)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
}
