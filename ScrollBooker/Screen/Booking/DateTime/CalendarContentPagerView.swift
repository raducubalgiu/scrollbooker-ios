//
//  CalendarContentPagerView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.07.2026.
//

import SwiftUI

struct CalendarContentPagerView: View {
    @Binding var currentDayPage: Int
    let slotsState: SocialTabState<Slot>
    let viewModel: BookingViewModel
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
                                ErrorView(message: "Eroare la încărcarea orelor") {}
                                
                            case .success(let availableSlotsList, _, _):
                                if availableSlotsList.isEmpty {
                                    FullyBookedDayMessageView(
                                        onNextOpenDayTap: {}
                                    )
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
