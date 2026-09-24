//
//  MyCalendarSlotView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarSlotView: View {
    let slot: CalendarEventsSlot
    let style: MyCalendarSlotStyle
    let height: CGFloat
    let offsetY: CGFloat
    var isBlocking: Bool = false
    var showCheckbox: Bool = false
    var isChecked: Bool = false
    var isCheckboxEnabled: Bool = true
    var onTap: (CalendarEventsSlot) -> Void = { _ in }

    private let minTouchHeight: CGFloat = 44

    var body: some View {
        let touchHeight = max(height, minTouchHeight)

        Button {
            onTap(slot)
        } label: {
            MyCalendarSlotContentView(
                slot: slot,
                lineColor: style.lineColor,
                height: height,
                isBefore: style.isBefore,
                isBlocking: isBlocking,
                showCheckbox: showCheckbox,
                isChecked: isChecked,
                isCheckboxEnabled: isCheckboxEnabled
            )
            .padding(8)
            .frame(maxWidth: .infinity, minHeight: height, alignment: .topLeading)
            .frame(height: touchHeight, alignment: .top)
            .background(style.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!style.isEnabled)
        .padding(.horizontal, 4)
        .frame(height: touchHeight)
        .offset(y: offsetY)
        .opacity(style.isEnabled ? 1 : 0.85)
    }
}
