//
//  PostOverlayView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct PostOverlayView: View {
    var post: Post
    
    @Environment(\.feedActions) private var actions
    
    private func makeProfileNavigationParams() -> ProfileNavigationParams {
        ProfileNavigationParams(
            userId: post.user.id,
            username: post.user.username
        )
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.6)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)
            .ignoresSafeArea(edges: .bottom)
            
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 15) {
                    PostUserView(
                        user: post.user,
                        onClick: { actions.onNavigateToUserProfile(makeProfileNavigationParams()) }
                    )
                    
                    if let description = post.description?.isEmpty == false ? post.description : nil {
                        PostDescriptionView(description: description)
                    }
                    
                    PostMainActionView(
                        onClick: { actions.onOpenLinkedProductsSheet(post.id) }
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, .base)
                
                PostActionsView(post: post)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .padding(.leading, .m)
            .padding(.bottom, .m)
            .padding(.trailing, .s)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

