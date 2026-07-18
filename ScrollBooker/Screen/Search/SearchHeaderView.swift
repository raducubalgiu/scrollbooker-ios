//
//  SearchHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import SwiftUI

struct SearchHeaderView: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
                .padding(.leading, 16)
            
            VStack(alignment: .leading, spacing: 3) {
                Text("Toate Serviciile")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("Oricand • Orice ora")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.primary.opacity(0.12), lineWidth: 1))
            }
            .padding(.trailing, 8)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundSB)
        .cornerRadius(28)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}
