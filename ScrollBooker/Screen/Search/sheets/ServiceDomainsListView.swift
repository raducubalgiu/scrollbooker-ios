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

struct ServiceDomainCardView: View {
    let name: String
    let thumbnailUrl: String?
    var onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.surfaceSB)

                    if let urlString = thumbnailUrl, let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            if case .success(let image) = phase {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .clipped()

                Text(name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
}
