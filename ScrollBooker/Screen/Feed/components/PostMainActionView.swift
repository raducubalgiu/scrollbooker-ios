//
//  PostMainActionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import SwiftUI

struct PostMainActionView: View {
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text("Rezervă acum")
                .font(.subheadline.bold())
                .foregroundColor(.white)
        }
        .padding(.vertical, 11)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.primarySB)
        )
        .buttonStyle(.plain)
    }
}

#Preview("Dark") {
    PostMainActionView(onClick: {})
        .preferredColorScheme(.dark)
}
