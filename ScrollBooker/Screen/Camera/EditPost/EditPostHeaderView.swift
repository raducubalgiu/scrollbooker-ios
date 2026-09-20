//
//  EditPostHeaderView.swift
//  ScrollBooker
//

import SwiftUI

struct EditPostHeaderView: View {
    let coverURL: String?
    let description: String
    var onDescriptionChange: (String) -> Void

    private let previewHeight: CGFloat = 160
    private let maxLength = 500

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: coverURL ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    Color.surfaceSB
                }
            }
            .frame(width: previewHeight * (9/12), height: previewHeight)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .trailing, spacing: 8) {
                TextField(
                    String(localized: "createPostDescriptionPlaceholder"),
                    text: Binding(
                        get: { description },
                        set: { onDescriptionChange($0) }
                    ),
                    axis: .vertical
                )
                .font(.subheadline)
                .lineLimit(5...5)
                .padding(8)

                Spacer()

                Text("\(description.count) / \(maxLength)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(height: previewHeight)
        }
    }
}
