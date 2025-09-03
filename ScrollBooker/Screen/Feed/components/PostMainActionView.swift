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
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.white)
                
                Text("Intervale disponibile")
                    .font(.headline.bold())
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 12.5)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.primarySB)
        )
        .buttonStyle(.plain)
    }
}

#Preview("Dark") {
    PostMainActionView(onClick: {})
        .preferredColorScheme(.dark)
}
