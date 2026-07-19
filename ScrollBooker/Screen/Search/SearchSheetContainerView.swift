//
//  SearchSheetContainer.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import SwiftUI

enum SheetPosition: CaseIterable {
    case collapsed
    case medium
    case expanded
}

struct SearchSheetContainerView: View {
    let isLoading: Bool
    let isPaging: Bool
    let businesses: [BusinessSheet]
    let totalCount: Int
    var onNavigateToBusinessProfile: (String) -> Void
    var onSelectProduct: (String) -> Void
    var onLoadMore: (BusinessSheet) -> Void

    @State private var sheetPosition: SheetPosition = .medium
    @State private var dragOffset: CGFloat = 0
    @State private var headerHeight: CGFloat = 56
    @State private var containerHeight: CGFloat = 0

    private let mediumVisibleRatio: CGFloat = 0.55
    private let velocityThreshold: CGFloat = 250

    var body: some View {
        GeometryReader { geometry in
            let sheetMaxHeight = max(0, geometry.size.height)
            let baseOffset = offset(for: sheetPosition, totalHeight: geometry.size.height)

            SearchBottomSheet(
                maxHeight: sheetMaxHeight,
                isLoading: isLoading,
                isPaging: isPaging,
                businesses: businesses,
                totalCount: totalCount,
                onNavigateToBusinessProfile: onNavigateToBusinessProfile,
                onSelectProduct: onSelectProduct,
                onLoadMore: onLoadMore,
                onHeaderHeightChange: { headerHeight = $0 }
            )
            .offset(y: max(0, baseOffset + dragOffset))
            .animation(.interactiveSpring(response: 0.35, dampingFraction: 0.85, blendDuration: 0), value: dragOffset)
            .animation(.spring(response: 0.4, dampingFraction: 0.85), value: sheetPosition)
            .gesture(dragGesture)
            .onAppear { containerHeight = geometry.size.height }
            .onChange(of: geometry.size.height) { _, newValue in
                containerHeight = newValue
            }
        }
    }

    private func offset(for position: SheetPosition, totalHeight: CGFloat) -> CGFloat {
        guard totalHeight > 0 else { return 600 }
        switch position {
        case .collapsed:
            return max(0, totalHeight - headerHeight)
        case .medium:
            return max(0, totalHeight - (totalHeight * mediumVisibleRatio))
        case .expanded:
            return 0
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 5)
            .onChanged(handleDragChanged)
            .onEnded(handleDragEnded)
    }

    private func handleDragChanged(_ value: DragGesture.Value) {
        guard abs(value.translation.height) > abs(value.translation.width) else { return }
        let proposed = value.translation.height

        switch sheetPosition {
        case .expanded:
            dragOffset = proposed < 0 ? proposed * 0.15 : proposed
        case .collapsed:
            dragOffset = proposed > 0 ? proposed * 0.1 : proposed
        case .medium:
            dragOffset = proposed
        }
    }

    private func handleDragEnded(_ value: DragGesture.Value) {
        guard abs(value.translation.height) > abs(value.translation.width) else {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                dragOffset = 0
            }
            return
        }

        let velocity = value.predictedEndTranslation.height
        let currentOffset = offset(for: sheetPosition, totalHeight: containerHeight) + value.translation.height

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            sheetPosition = nextPosition(from: currentOffset, velocity: velocity)
            dragOffset = 0
        }
    }

    private func nextPosition(from currentOffset: CGFloat, velocity: CGFloat) -> SheetPosition {
        guard containerHeight > 0 else { return sheetPosition }

        if velocity < -velocityThreshold {
            return sheetPosition == .collapsed ? .medium : .expanded
        }
        if velocity > velocityThreshold {
            return sheetPosition == .expanded ? .medium : .collapsed
        }

        return SheetPosition.allCases.min { lhs, rhs in
            let lhsOffset = offset(for: lhs, totalHeight: containerHeight)
            let rhsOffset = offset(for: rhs, totalHeight: containerHeight)
            return abs(lhsOffset - currentOffset) < abs(rhsOffset - currentOffset)
        } ?? sheetPosition
    }
}
