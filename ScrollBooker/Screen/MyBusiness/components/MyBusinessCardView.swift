//
//  MyBusinessCardView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.08.2025.
//

import SwiftUI

struct MyBusinessCardView: View {
    var title: String = ""
    var description: String = ""
    var icon: String = ""
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.onBackgroundSB)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.onBackgroundSB)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.onSurfaceSB)
            }
            .padding(.base)
            .frame(maxWidth: .infinity, minHeight: CGFloat(200))
            .background(.surface)
            .cornerRadius(12)
            .contentShape(Rectangle())
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
