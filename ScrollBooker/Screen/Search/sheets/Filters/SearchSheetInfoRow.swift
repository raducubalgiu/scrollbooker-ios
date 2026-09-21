//
//  SearchSheetInfoRow.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import SwiftUI

struct SearchSheetInfoRow: View {
    let leftText: String
    let rightText: String
    
    var body: some View {
        HStack {
            Text(leftText)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            if !rightText.isEmpty {
                Text(rightText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .bold()
            }
        }
    }
}
