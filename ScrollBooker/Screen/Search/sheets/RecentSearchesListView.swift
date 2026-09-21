//
//  RecentSearchesListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct RecentSearchesListView: View {
    let recentSearches: [RecentSearch]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
            Text(String(localized: "recentSearches"))
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.onBackgroundSB)

            VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                ForEach(recentSearches) { search in
                    HStack(spacing: AppSize.base.rawValue) {
                        ZStack {
                            Circle()
                                .fill(Color.primarySB.opacity(0.12))
                                .frame(width: 40, height: 40)

                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primarySB)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(search.serviceDomain.name)
                                .font(.system(size: 16, weight: .semibold))

                            if let label = search.displayLabel {
                                Text(label)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }

                        Spacer()
                    }
                }
            }
        }
    }
}
