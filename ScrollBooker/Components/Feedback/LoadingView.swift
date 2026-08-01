//
//  LoadingView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct LoadingView: View {
    var maxHeight: CGFloat = .infinity
    
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.1)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: maxHeight)
    }
}
