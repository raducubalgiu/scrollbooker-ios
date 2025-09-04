//
//  BulletListItem.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct BulletListItem: View {
    var text: String
    var color: Color = .onBackgroundSB
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .frame(width: 6, height: 6)
                .foregroundStyle(.gray)
                .padding(.top, 7)
            
            Text(text)
                .foregroundColor(color)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Light") {
    BulletListItem(
        text: "Some dummy text goes here"
    )
    .padding()
    
    Spacer()
}

#Preview("Dark") {
    BulletListItem(
        text: "Some dummy text goes here"
    )
    .padding()
    .preferredColorScheme(.dark)
    
    Spacer()
}
