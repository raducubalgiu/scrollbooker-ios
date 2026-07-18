//
//  NearbyBusinessImage.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.07.2026.
//

import SwiftUI

struct NearbyBusinessImageView: View {
    let url: String?
    let username: String
    
    var body: some View {
        let isPlaceholder = url == nil || url?.isEmpty == true || url == "placeholder.jpg"
        
        ZStack(alignment: .center) {
            if !isPlaceholder, let urlString = url, let imageUrl = URL(string: urlString) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.surfaceSB
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text((username.first?.uppercaseString ?? ""))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB.opacity(0.4))
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(16.0 / 9.0, contentMode: .fit)
        .background(Color.surfaceSB)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private extension Character {
    var uppercaseString: String {
        String(self).uppercaseString
    }
}
private extension String {
    var uppercaseString: String {
        self.uppercased()
    }
}
