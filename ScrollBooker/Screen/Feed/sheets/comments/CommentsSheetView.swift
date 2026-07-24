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
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack {
                    switch viewModel.viewState {
                    case .idle, .loading:
                        LoadingView()
                        
                    case .error(let message):
                        ErrorView(message: message) {
                            Task { await viewModel.loadComments() }
                        }
                        
                    case .success(let comments):
                        if comments.isEmpty {
                            NoDataView(
                                title: "Comentarii",
                                message: "Fii primul care lasă un comentariu la această postare!",
                                systemImage: "bubble.left"
                            )
                            .frame(maxHeight: .infinity)
                        } else {
                            ScrollView(.vertical) {
                                LazyVStack(spacing: 12) {
                                    ForEach(comments, id: \.id) { comment in
                                        CommentRowView(
                                            comment: comment,
                                            onNavigateToUserProfile: {
                                                dismiss()

                                                onNavigateToUserProfile($0)
                                            }
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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                CommentFooterView(onCreateComment: { text, parentId in
                    Task {
                        // Aici vei apela funcția din ViewModel-ul tău pentru a salva comentariul pe server
                        // ex: await viewModel.sendNewComment(text: text, parentId: parentId)
                        print("Trimite comentariu nou: \(text), parent: \(String(describing: parentId))")
                    }
                })
            }
        }
        .task {
            await viewModel.loadComments()
        }
    }
}
