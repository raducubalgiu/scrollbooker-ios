//
//  MyCalendarTimeGutterView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarTimeGutterView: View {
    let ticks: [Int]
    let dayStartMinutes: Int
    let dpPerMinute: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(ticks, id: \.self) { tick in
                Text(formatMinutesAsClock(tick))
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .offset(y: CGFloat(tick - dayStartMinutes) * dpPerMinute + 2)
                    .padding(.leading, 8)
            }
        }
        .frame(width: 56, height: height, alignment: .topLeading)
    }
}
