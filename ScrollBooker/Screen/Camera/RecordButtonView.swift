//
//  RecordButtonView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.07.2026.
//

import SwiftUI

struct RecordButtonView: View {
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Circle()
                .strokeBorder(Color.white, lineWidth: 4)
                .background(Circle().fill(Color.red.opacity(0.3)))
                .frame(width: 74, height: 74)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 60, height: 60)
                )
        }
    }
}
