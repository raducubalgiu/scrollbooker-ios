//
//  SearchSheetContainer.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import SwiftUI

enum SheetPosition {
    case collapsed
    case expanded
}

/// Gestionează poziția (collapsed/expanded) și gestul de drag al bottom sheet-ului.
/// Are propriul @State, izolat de restul ecranului: dragOffset se schimbă de zeci de ori
/// pe secundă în timpul gestului, dar asta nu mai invalidează harta sau header-ul.
struct SearchSheetContainerView: View {
    let isLoading: Bool
    let isPaging: Bool
    let businesses: [BusinessSheet]
    let totalCount: Int
    var onNavigateToBusinessProfile: (String) -> Void
    var onSelectProduct: (String) -> Void
    var onLoadMore: (BusinessSheet) -> Void

    @State private var sheetPosition: SheetPosition = .collapsed
    @State private var dragOffset: CGFloat = 0
    // Înălțimea reală a header-ului din SearchBottomSheet (capsulă + text), măsurată live.
    // Nu mai folosim o valoare hardcodată: dacă header-ul se schimbă vizual, collapse-ul
    // rămâne mereu corect, fără să mai umblăm la vreo constantă.
    @State private var headerHeight: CGFloat = 56

    private let expandThreshold: CGFloat = 60
    private let velocityThreshold: CGFloat = 100

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
        }
    }

    private func offset(for position: SheetPosition, totalHeight: CGFloat) -> CGFloat {
        guard totalHeight > 0 else { return 600 }
        switch position {
        case .collapsed:
            // Sheet-ul are exact înălțimea totalHeight (maxHeight == geometry.size.height),
            // deci ca să rămână vizibil DOAR header-ul, îl împingem în jos cu
            // (totalHeight - headerHeight) — nimic mai mult, nimic mai puțin.
            return max(0, totalHeight - headerHeight)
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

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            if velocity < -velocityThreshold {
                sheetPosition = .expanded
            } else if velocity > velocityThreshold {
                sheetPosition = .collapsed
            } else {
                sheetPosition = value.translation.height < -expandThreshold ? .expanded : .collapsed
            }
            dragOffset = 0
        }
    }
}
