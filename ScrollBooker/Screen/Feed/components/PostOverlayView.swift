//
//  PostOverlayView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct PostOverlayView: View {
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text("Salsa Factory")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                HStack {
                    Text("Scoala de dans")
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
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Tuns Special")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                        
                        Text("200 RON")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                
                Text("Lorem Ipsum is simply dummy text of...")
                    .foregroundColor(.white)
                    .padding(.top, .s)
                
                MainButton(
                    title: "Intervale disponibile",
                    onClick: {}
                )
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center, spacing: 20) {
                AvatarView(
                    imageURL: URL(string: "https://media.scrollbooker.ro/avatar-male-9.jpeg"),
                    size: .l
                )
                
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                    Text("100")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "ellipsis.message.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 35))
                    Text("50")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                    Text("100")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .center, spacing: 2) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                    Text("100")
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
    PostOverlayView()
        .preferredColorScheme(.dark)
}
