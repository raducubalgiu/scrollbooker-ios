//
//  BookingSummaryItemView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct BookingSummaryItemView: View {
    let title: String
    let description: String
    let systemIcon: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 48, height: 48)
                
                Image(systemName: systemIcon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.accentColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB)
                
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.all, .base)
    }
}
