//
//  ServiceDomainsListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ServiceDomainsListView: View {
    var serviceDomains: [ServiceDomain]
    var onSetServiceDomain: (ServiceDomain) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: AppSize.base.rawValue),
        GridItem(.flexible(), spacing: AppSize.base.rawValue)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
            Text(String(localized: "categories"))
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.onBackgroundSB)

            LazyVGrid(columns: columns, spacing: AppSize.base.rawValue) {
                ForEach(serviceDomains) { domain in
                    ServiceDomainCardView(
                        name: domain.name,
                        thumbnailUrl: domain.thumbnailUrl,
                        onClick: { onSetServiceDomain(domain) }
                    )
                }
            }
        }
    }
}
