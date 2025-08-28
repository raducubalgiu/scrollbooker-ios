//
//  CounterView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI

struct ProfileCounterView: View {
    var counter: Int? = 0
    var label: String
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            VStack(spacing: 5) {
                Text(counter != nil ? "\(counter!)" : "-")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB)
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.onBackgroundSB)
            }
        }
    }
}

#Preview("Light") {
    ProfileCounterView(
        label: "Recenzii",
        onClick: {}
    )
}

#Preview("Dark") {
    ProfileCounterView(
        label: "Recenzii",
        onClick: {}
    )
        .preferredColorScheme(.dark)
}
