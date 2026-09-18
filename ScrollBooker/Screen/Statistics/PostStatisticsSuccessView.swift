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

    private struct QuickStat: Identifiable {
        let id: String
        let icon: String
        let value: Int
    }

    private var quickStats: [QuickStat] {
        [
            QuickStat(id: "totalViews", icon: "play", value: summary.viewsCount),
            QuickStat(id: "likes", icon: "heart", value: summary.likeCount),
            QuickStat(id: "comments", icon: "ellipsis.message", value: summary.commentCount),
            QuickStat(id: "shares", icon: "arrowshape.turn.up.right", value: summary.shareCount),
            QuickStat(id: "saves", icon: "bookmark", value: summary.bookmarkCount)
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
            thumbnail
                .frame(maxWidth: .infinity, alignment: .center)

            HStack(spacing: 0) {
                ForEach(quickStats) { stat in
                    VStack(spacing: 4) {
                        Image(systemName: stat.icon)
                            .font(.system(size: 18))
                            .foregroundColor(.onBackgroundSB)

                        Text("\(stat.value)")
                            .font(.subheadline.bold())
                            .foregroundColor(.onBackgroundSB)

                        Text(String(localized: String.LocalizationValue(stat.id)))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, .s)

            Text(String(localized: "postStatisticsSummary"))
                .font(.subheadline.bold())

            HStack(spacing: AppSize.m.rawValue) {
                StatCardView(
                    label: String(localized: "views"),
                    value: "\(summary.viewsCount)",
                    labelFont: .caption.bold(),
                    valueFont: .headline.bold()
                )
                StatCardView(
                    label: String(localized: "uniqueViewers"),
                    value: "\(summary.uniqueViewersCount)",
                    labelFont: .caption.bold(),
                    valueFont: .headline.bold()
                )
            }

            HStack(spacing: AppSize.m.rawValue) {
                StatCardView(
                    label: String(localized: "watchTime"),
                    value: formatMillis(summary.watchTimeMs),
                    labelFont: .caption.bold(),
                    valueFont: .headline.bold()
                )
                StatCardView(
                    label: String(localized: "averageWatchTime"),
                    value: formatMillis(summary.averageWatchTimeMs),
                    labelFont: .caption.bold(),
                    valueFont: .headline.bold()
                )
            }

            if !groupedSources.isEmpty {
                Text(String(localized: "trafficSources"))
                    .font(.subheadline.bold())
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

    private var thumbnail: some View {
        AsyncImage(url: summary.thumbnailURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure, .empty:
                Color(.systemGray5)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 130, height: 130 * 12 / 9)
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
