//
//  UnapprovedBusinessesListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct UnapprovedBusinessesListView: View {
    let businesses: [UnapprovedBusiness]
    let isPaging: Bool
    let approvingBusinessId: Int?
    let onRefresh: () async -> Void
    let onItemAppear: (UnapprovedBusiness) -> Void
    let onApprove: (UnapprovedBusiness) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: AppSize.s.rawValue) {
                ForEach(businesses) { item in
                    UnapprovedBusinessItemView(
                        item: item,
                        isApproving: approvingBusinessId == item.id,
                        onReject: {},
                        onApprove: { onApprove(item) }
                    )
                    .onAppear {
                        onItemAppear(item)
                    }
                }

                if isPaging {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                }
            }
            .padding(.base)
        }
        .refreshable {
            await onRefresh()
        }
    }
}
