//
//  PostStatisticsSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import SwiftUI

struct PostStatisticsSuccessView: View {
    let summary: PostAnalyticsSummary

    private struct GroupedSource: Identifiable {
        let id: String
        let label: String
        let viewsCount: Int
    }

    private var groupedSources: [GroupedSource] {
        let grouped = Dictionary(grouping: summary.sourceBreakdown) { item in
            item.source?.labelKey ?? PostViewSourceEnum.other.labelKey
        }

        return grouped
            .map { labelKey, items -> (label: String, viewsCount: Int, minOrdinal: Int) in
                let totalViews = items.reduce(0) { $0 + $1.viewsCount }
                let minOrdinal = items
                    .compactMap { $0.source.flatMap { PostViewSourceEnum.allCases.firstIndex(of: $0) } }
                    .min() ?? Int.max
                let label = items.first?.source?.localizedLabel
                    ?? String(localized: String.LocalizationValue(labelKey))

                return (label, totalViews, minOrdinal)
            }
            .sorted { $0.minOrdinal < $1.minOrdinal }
            .map { GroupedSource(id: $0.label, label: $0.label, viewsCount: $0.viewsCount) }
    }

    private var maxViews: Int {
        max(groupedSources.map(\.viewsCount).max() ?? 1, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
            HStack(spacing: AppSize.m.rawValue) {
                StatCardView(label: String(localized: "views"), value: "\(summary.viewsCount)")
                StatCardView(label: String(localized: "uniqueViewers"), value: "\(summary.uniqueViewersCount)")
            }

            HStack(spacing: AppSize.m.rawValue) {
                StatCardView(label: String(localized: "watchTime"), value: formatMillis(summary.watchTimeMs))
                StatCardView(label: String(localized: "averageWatchTime"), value: formatMillis(summary.averageWatchTimeMs))
            }

            if !groupedSources.isEmpty {
                Text(String(localized: "trafficSources"))
                    .font(.title3.bold())
                    .padding(.top, .s)

                VStack(spacing: AppSize.base.rawValue) {
                    ForEach(groupedSources) { group in
                        StatBarRowView(
                            label: group.label,
                            valueString: "\(group.viewsCount)",
                            progressPercentage: Float(group.viewsCount) / Float(maxViews)
                        )
                    }
                }
            }
        }
    }

    private func formatMillis(_ ms: Int) -> String {
        let totalSeconds = ms / 1000
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
}
