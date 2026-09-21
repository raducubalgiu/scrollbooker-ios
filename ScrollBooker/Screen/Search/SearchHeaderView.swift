//
//  SearchHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import SwiftUI

struct SearchHeaderView: View {
    var headline: String
    var subHeadline: String
    var activeFiltersCount: Int
    var onServicesTap: () -> Void
    var onFiltersTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primary)
                    .padding(.leading, 16)

                VStack(alignment: .leading, spacing: 3) {
                    Text(headline)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    Text(subHeadline)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onServicesTap()
            }

            SearchFiltersButtonView(
                activeFiltersCount: activeFiltersCount,
                onFilter: onFiltersTap
            )
            .padding(.trailing, 8)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundSB)
        .cornerRadius(50)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

struct SearchFiltersButtonView: View {
    var activeFiltersCount: Int
    var onFilter: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: onFilter) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(
                            activeFiltersCount > 0 ? Color.onBackgroundSB : Color.dividerSB,
                            lineWidth: activeFiltersCount > 0 ? 2 : 1
                        )
                    )
            }

            if activeFiltersCount > 0 {
                Text("\(activeFiltersCount)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 18, height: 18)
                    .background(Circle().fill(Color.primarySB))
                    .overlay(Circle().stroke(Color.backgroundSB, lineWidth: 2))
                    .offset(x: 4, y: -4)
            }
        }
    }
}
