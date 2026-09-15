//
//  FeedDrawerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import SwiftUI

struct FeedDrawerView: View {
    let serviceDomainsState: FeatureState<[ServiceDomain]>
    let selectedServiceIds: Set<Int>
    let onlyVideoReviews: Bool
    let isOpen: Bool
    let onApplyFilters: (Set<Int>, Bool) -> Void
    let onRequestClose: () -> Void

    @State private var draftSelectedIds: Set<Int> = []
    @State private var draftOnlyVideoReviews: Bool = false

    private var isClearEnabled: Bool {
        !draftSelectedIds.isEmpty || draftOnlyVideoReviews
    }

    var body: some View {
        VStack(spacing: 0) {
            switch serviceDomainsState {
            case .idle, .loading:
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .error:
                VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                    FeedDrawerHeaderView()

                    Text(String(localized: "somethingWentWrong"))
                        .foregroundColor(Color(white: 0.67))
                }
                .padding(.horizontal, .base)

            case .success(let domains):
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSize.xl.rawValue) {
                        FeedDrawerHeaderView()

                        FeedDrawerVideoReviewsToggleView(checked: $draftOnlyVideoReviews)

                        Divider().background(Color(white: 0.23))

                        Text(String(localized: "categories"))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(white: 0.47))

                        ForEach(domains) { domain in
                            FeedDrawerDomainSectionView(
                                domain: domain,
                                selectedServiceIds: draftSelectedIds,
                                onToggleService: { serviceId in
                                    if draftSelectedIds.contains(serviceId) {
                                        draftSelectedIds.remove(serviceId)
                                    } else {
                                        draftSelectedIds.insert(serviceId)
                                    }
                                }
                            )

                            if domain.id != domains.last?.id {
                                Divider().background(Color(white: 0.16))
                            }
                        }
                    }
                    .padding(.horizontal, .base)
                }

                FeedDrawerActionsView(
                    isClearEnabled: isClearEnabled,
                    selectedCount: draftSelectedIds.count,
                    onClear: {
                        draftSelectedIds = []
                        draftOnlyVideoReviews = false
                    },
                    onConfirm: onRequestClose
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.black.ignoresSafeArea())
        .onChange(of: isOpen) { _, newValue in
            if newValue {
                draftSelectedIds = selectedServiceIds
                draftOnlyVideoReviews = onlyVideoReviews
            } else {
                onApplyFilters(draftSelectedIds, draftOnlyVideoReviews)
            }
        }
    }
}
