//
//  OpeningHoursSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.09.2025.
//

import SwiftUI

struct OpeningHoursSheetView: View {
    let profileController: ProfileController
    let userId: Int

    @Environment(\.dismiss) private var dismiss
    @State private var measuredHeight: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(
                onDismiss: { dismiss() },
                title: String(localized: "schedule"),
                showDivider: false
            )

            content
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { measuredHeight = geo.size.height }
                    .onChange(of: geo.size.height) { _, new in
                        measuredHeight = new
                    }
            }
        )
        .presentationDetents([.height(max(100, measuredHeight + 16))])
        .presentationContentInteraction(.resizes)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(25)
        .task {
            await profileController.loadScheduleIfNeeded(userId: userId)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch profileController.scheduleState {
        case .idle, .loading:
            VStack(spacing: 0) {
                ForEach(0..<7, id: \.self) { _ in
                    OpeningHoursSkeletonRowView()
                }
            }
            .padding(.horizontal)
            .padding(.bottom, .s)

        case .error(let message):
            ErrorView(message: message, maxHeight: 220) {
                Task { await profileController.loadScheduleIfNeeded(userId: userId) }
            }

        case .success(let schedules):
            VStack(spacing: 0) {
                ForEach(schedules) { schedule in
                    OpeningHoursRowView(schedule: schedule)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, .s)
        }
    }
}

private struct OpeningHoursRowView: View {
    let schedule: Schedule

    var body: some View {
        HStack {
            HStack(spacing: AppSize.s.rawValue) {
                Circle()
                    .fill(schedule.isClosed ? Color.gray : Color.green)
                    .frame(width: 8, height: 8)

                Text(schedule.localizedDayOfWeek)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)
            }

            Spacer()

            Text(schedule.timeRangeDisplay)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
        }
        .padding(.vertical, .s)
    }
}

private struct OpeningHoursSkeletonRowView: View {
    var body: some View {
        HStack {
            HStack(spacing: AppSize.s.rawValue) {
                Circle()
                    .fill(Color.primary.opacity(0.07))
                    .frame(width: 8, height: 8)

                SkeletonBar(width: 70, height: 14)
            }

            Spacer()

            SkeletonBar(width: 90, height: 14)
        }
        .padding(.vertical, .s)
    }
}
