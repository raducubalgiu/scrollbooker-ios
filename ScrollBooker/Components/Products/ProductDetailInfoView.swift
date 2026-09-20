//
//  ProductDetailInfoView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.09.2026.
//

import SwiftUI

struct ProductDetailInfoView: View {
    let name: String
    let description: String?

    @State private var isDescriptionExpanded = false
    @State private var isDescriptionTruncated = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.xxs.rawValue) {
            Text(name)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.onBackgroundSB)

            if let description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.onBackgroundSB)
                    .lineLimit(isDescriptionExpanded ? nil : 1)
                    .truncationMode(.tail)
                    .modifier(TextTruncationDetector(text: description, font: .subheadline, isTruncated: $isDescriptionTruncated))

                if isDescriptionTruncated {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isDescriptionExpanded.toggle()
                        }
                    }) {
                        Text(String(localized: isDescriptionExpanded ? "seeLess" : "seeMore"))
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.primarySB)
                    }
                }
            } else {
                Text(String(localized: "serviceWithoutDescription"))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, .base)
    }
}

private struct TextTruncationDetector: ViewModifier {
    let text: String
    let font: Font
    @Binding var isTruncated: Bool

    @State private var oneLineHeight: CGFloat = 0
    @State private var fullHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    ZStack {
                        Text(text)
                            .font(font)
                            .lineLimit(1)
                            .background(
                                GeometryReader { lineGeometry in
                                    Color.clear.onAppear { oneLineHeight = lineGeometry.size.height }
                                }
                            )

                        Text(text)
                            .font(font)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: proxy.size.width, alignment: .leading)
                            .background(
                                GeometryReader { fullGeometry in
                                    Color.clear.onAppear { fullHeight = fullGeometry.size.height }
                                }
                            )
                    }
                    .hidden()
                }
            )
            .onChange(of: oneLineHeight) { _, _ in updateTruncation() }
            .onChange(of: fullHeight) { _, _ in updateTruncation() }
    }

    private func updateTruncation() {
        guard oneLineHeight > 0, fullHeight > 0 else { return }
        isTruncated = fullHeight > oneLineHeight + 1
    }
}
