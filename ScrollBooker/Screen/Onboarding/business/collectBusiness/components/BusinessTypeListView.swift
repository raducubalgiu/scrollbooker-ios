//
//  BusinessTypeListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import SwiftUI

struct BusinessTypeListView: View {
    let businessTypes: [BusinessType]
    let selectedBusinessType: BusinessType?
    let isPaging: Bool
    let onSelect: (BusinessType) -> Void
    let onLoadMore: (BusinessType) -> Void
    let onRefresh: () async -> Void

    var body: some View {
        List {
            ForEach(Array(businessTypes.enumerated()), id: \.element.id) { index, businessType in
                VStack(spacing: 0) {
                    InputRadio(
                        title: businessType.name,
                        isSelected: selectedBusinessType?.id == businessType.id,
                        onClick: { onSelect(businessType) }
                    )

                    if index < businessTypes.count - 1 {
                        Divider()
                            .opacity(0.5)
                            .padding(.vertical, .base)
                    }
                }
                .padding(.horizontal, .xxl)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .onAppear {
                    onLoadMore(businessType)
                }
            }

            if isPaging {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .refreshable {
            await onRefresh()
        }
    }
}
