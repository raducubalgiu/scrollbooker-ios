//
//  MyCalendarTimeGridView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import SwiftUI

struct MyCalendarTimeGridView: View {
    let ticks: [Int]
    let dayStartMinutes: Int
    let dpPerMinute: CGFloat
    let height: CGFloat

    var body: some View {
        Canvas { context, size in
            for tick in ticks {
                let y = CGFloat(tick - dayStartMinutes) * dpPerMinute
                let isHour = tick % 60 == 0

                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))

                context.stroke(
                    path,
                    with: .color(.black.opacity(isHour ? 0.08 : 0.05)),
                    lineWidth: 1
                )
            }
        }
        .frame(height: height)
    }
}
