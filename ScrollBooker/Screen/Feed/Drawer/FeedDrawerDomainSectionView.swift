//
//  FeedDrawerDomainSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import SwiftUI

struct FeedDrawerDomainSectionView: View {
    let domain: ServiceDomain
    let selectedServiceIds: Set<Int>
    let onToggleService: (Int) -> Void

    private var selectedCount: Int {
        domain.services.filter { selectedServiceIds.contains($0.id) }.count
    }

    var body: some View {
        if !domain.services.isEmpty {
            VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                HStack(spacing: AppSize.s.rawValue) {
                    if let thumbnailURL = domain.thumbnailURL {
                        AsyncImage(url: thumbnailURL) { phase in
                            if case .success(let image) = phase {
                                image.resizable().aspectRatio(contentMode: .fill)
                            } else {
                                Color(white: 0.15)
                            }
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    Text(domain.name)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(white: 0.88))
                        .lineLimit(1)

                    if selectedCount > 0 {
                        Text("\(selectedCount)")
                            .font(.caption2.bold())
                            .foregroundColor(.onPrimarySB)
                            .frame(width: 20, height: 20)
                            .background(Circle().fill(Color.primarySB))
                            .transition(.scale.combined(with: .opacity))
                    }

                    Spacer()
                }

                FlowLayout(horizontalSpacing: 10, verticalSpacing: 10) {
                    ForEach(domain.services) { service in
                        FeedDrawerServiceChipView(
                            label: service.shortName,
                            isSelected: selectedServiceIds.contains(service.id),
                            onClick: { onToggleService(service.id) }
                        )
                    }
                }
            }
            .animation(.easeInOut(duration: 0.15), value: selectedCount)
        }
    }
}
