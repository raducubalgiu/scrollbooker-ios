//
//  PostOverlayView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct PostOverlayView: View {
    var post: Post
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text(post.user.fullName)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                HStack {
                    Text(post.user.profession ?? "")
                        .foregroundColor(.primarySB)
                    Image(systemName: "location")
                        .foregroundColor(.white)
                    Text("5 km")
                        .foregroundColor(.white)
                }
                .padding(.bottom, .s)
                
                Divider()
                    .background(.white)
                    .padding(.bottom, .s)
                
                if let product = post.product {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .font(.headline.bold())
                                .foregroundColor(.white)
                            
                            Text("\(product.priceWithDiscount) \(product.currency.name)")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                if let description = post.description {
                    Text(description)
                        .foregroundColor(.white)
                        .padding(.top, .s)
                }
                
                MainButton(
                    title: "Intervale disponibile",
                    onClick: {}
                )
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center, spacing: 20) {
                AvatarView(
                    imageURL: post.user.avatarURL,
                    size: .l
                )
                
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                    Text("\(post.counters.likeCount)")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "ellipsis.message.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 35))
                    Text("\(post.counters.commentCount)")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                    Text("\(post.counters.bookmarkCount)")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                    Text("\(post.counters.shareCount)")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.leading)
        .padding(.bottom)
    }
}

#Preview("Post Overlay") {
    PostOverlayView(
        post: dummyBookNowPosts[0]
    )
        .preferredColorScheme(.dark)
}
