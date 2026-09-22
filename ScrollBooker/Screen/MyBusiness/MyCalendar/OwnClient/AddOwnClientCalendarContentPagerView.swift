//
//  AddOwnClientCalendarContentPagerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI

struct AddOwnClientCalendarContentPagerView: View {
    @Binding var currentDayPage: Int
    let slotsState: FeatureState<[Slot]>
    let viewModel: AddOwnClientViewModel
    var onNextOpenDayTap: (() -> Void)? = nil
    var onSlotSelected: (Slot) -> Void

    private let totalDays = 26 * 7

    var body: some View {
        TabView(selection: $currentDayPage) {
            ForEach(0..<totalDays, id: \.self) { pageIndex in
                VStack {
                    if pageIndex == currentDayPage {
                        switch slotsState {
                            case .idle, .loading:
                                SlotsShimmerView()

                            case .error:
                                ErrorView(message: String(localized: "message_error_loading_hours")) {}

                            case .success(let availableSlotsList):
                                if availableSlotsList.isEmpty {
                                    FullyBookedDayMessageView(
                                        onNextOpenDayTap: onNextOpenDayTap
                                    )
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                } else {
                                    ScrollView {
                                        LazyVStack(spacing: 12) {
                                            ForEach(availableSlotsList) { slot in
                                                SlotItemView(
                                                    slot: slot,
                                                    onSelectSlot: onSlotSelected
                                                )
                                            }
                                        }
                                        .padding(.bottom, 24)
                                    }
                                    .scrollDismissesKeyboard(.immediately)
                                    .refreshable {
                                        await viewModel.refreshTimeSlotsForCurrentDay()
                                    }
                                }
                            }
                    } else {
                        Color.clear
                    }
                }
                .tag(pageIndex)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}
