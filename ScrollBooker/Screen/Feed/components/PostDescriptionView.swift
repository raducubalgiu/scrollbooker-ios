//
//  PostDescriptionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import SwiftUI

struct PostDescriptionView: View {
    var description: String = ""
    
    var body: some View {
        Text(description)
            .foregroundColor(.white)
            .lineLimit(2)
            .truncationMode(.tail)
    }
}

#Preview("Light") {
    PostDescriptionView()
}

#Preview("Dark") {
    PostDescriptionView()
        .preferredColorScheme(.dark)
}
