//
//  MyBusinessCardView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.08.2025.
//

import SwiftUI

struct MyBusinessCardView: View {
    let title: String
    let description: String
    let icon: String
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            VStack(alignment: .leading, spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.onSurfaceSB)
                
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.onBackgroundSB)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(3, reservesSpace: true)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
            }
            .padding(.base)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surfaceSB)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Light") {
    MyBusinessCardView(
        title: "Program",
        description: "Detalii despre programul meu",
        icon: "bag",
        onClick: {}
    )
}

#Preview("Dark") {
    MyBusinessCardView(
        title: "Program",
        description: "Detalii despre programul meu",
        icon: "bag",
        onClick: {}
    )
        .preferredColorScheme(.dark)
}
