//
//  PostActionsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import SwiftUI

struct PostActionsView: View {
    var userAvatarURL: URL?
    var counters: PostCounters
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            AvatarView(
                imageURL: userAvatarURL,
                size: .m
            )
            
            VStack(alignment: .center, spacing: 2) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                Text("\(counters.likeCount)")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .center, spacing: 2) {
                Image(systemName: "ellipsis.message.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                Text("\(counters.commentCount)")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .center, spacing: 2) {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                Text("\(counters.bookmarkCount)")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .center, spacing: 2) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                Text("\(counters.shareCount)")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview("Dark") {
    PostActionsView(
        userAvatarURL: dummyBookNowPosts[0].user.avatarURL,
        counters: dummyBookNowPosts[0].counters
    )
        .preferredColorScheme(.dark)
}

