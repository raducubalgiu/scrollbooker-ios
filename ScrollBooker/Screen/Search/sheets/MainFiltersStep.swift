//
//  MainFiltersStep.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

struct MainFiltersStep: View {
    var businessDomains: [BusinessDomain]
    var recentSearchesState: FeatureState<[RecentSearch]>
    var onSetServiceDomain: (ServiceDomain) -> Void
    var onSelectRecentSearch: (RecentSearch) -> Void
    var onClose: () -> Void

    private var serviceDomains: [ServiceDomain] {
        businessDomains.flatMap { $0.serviceDomains }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(10)
                        .clipShape(Circle())
                }
            }
            .padding()

            Text(String(localized: "services"))
                .font(.largeTitle)
                .bold()
                .padding(.horizontal, .base)
                .padding(.bottom, .base)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSize.xxl.rawValue) {
                    if case .success(let recentSearches) = recentSearchesState, !recentSearches.isEmpty {
                        RecentSearchesListView(
                            recentSearches: recentSearches,
                            onSelect: onSelectRecentSearch
                        )
                    }

                    ServiceDomainsListView(
                        serviceDomains: serviceDomains,
                        onSetServiceDomain: onSetServiceDomain
                    )
                }
                .padding(.horizontal, .base)
                .padding(.bottom, .xxl)
            }
        }
    }
}
