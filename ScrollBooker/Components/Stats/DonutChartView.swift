//
//  DonutChartView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct DonutChartEntry: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let value: Int
    let color: Color
}

struct DonutChartView: View {
    let title: String
    let entries: [DonutChartEntry]

    @State private var animationProgress: CGFloat = 0

    private var total: Int {
        entries.reduce(0) { $0 + $1.value }
    }

    private var segments: [(start: CGFloat, length: CGFloat, color: Color)] {
        guard total > 0 else { return [] }

        var start: CGFloat = 0
        return entries.map { entry in
            let length = CGFloat(entry.value) / CGFloat(total)
            let segment = (start: start, length: length, color: entry.color)
            start += length
            return segment
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            Text(title)
                .font(.headline.bold())
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)

            ZStack {
                if total > 0 {
                    ForEach(Array(segments.enumerated()), id: \.offset) { _, segment in
                        Circle()
                            .trim(from: segment.start, to: segment.start + (segment.length * animationProgress))
                            .stroke(segment.color, style: StrokeStyle(lineWidth: 30, lineCap: .butt))
                            .rotationEffect(.degrees(-90))
                    }
                } else {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 30))
                }

                VStack(spacing: 2) {
                    Text("\(total)")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 150, height: 150)

            HStack(spacing: 0) {
                ForEach(entries) { entry in
                    legendItem(entry)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.base)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.dividerSB, lineWidth: 0.55)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animationProgress = 1
            }
        }
    }

    private func legendItem(_ entry: DonutChartEntry) -> some View {
        let percentage = total > 0 ? Int((Double(entry.value) / Double(total)) * 100) : 0

        return HStack(spacing: 8) {
            Circle()
                .fill(entry.color)
                .frame(width: 12, height: 12)

            VStack(alignment: .leading, spacing: 0) {
                Text(entry.label)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(percentage)%")
                    .font(.subheadline.bold())
                    .foregroundColor(.black)
            }
        }
    }
}
