//
//  PostDescriptionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import SwiftUI

struct PostDescriptionView: View {
    var description: String = ""
    var isExpanded: Bool = false
    var onToggle: () -> Void = {}

    var body: some View {
        Text(description)
            .font(.subheadline)
            .foregroundColor(.white)
            .lineLimit(isExpanded ? nil : 2)
            .truncationMode(.tail)
            .contentShape(Rectangle())
            .onTapGesture {
                onToggle()
            }
    }
}

#Preview("Light") {
    PostDescriptionView()
}

#Preview("Dark") {
    PostDescriptionView()
        .preferredColorScheme(.dark)
}
