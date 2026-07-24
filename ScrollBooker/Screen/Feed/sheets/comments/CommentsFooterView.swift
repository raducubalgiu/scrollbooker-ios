//
//  CommentsFooterView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 24.07.2026.
//

import SwiftUI

struct CommentFooterView: View {
    var onCreateComment: (String, Int?) -> Void
    
    private let emoticons = [
        "👌", "😁", "😇", "🤣", "😍", "🥰"
    ]
    
    @State private var text: String = ""
    @State private var parentId: Int? = nil

    var body: some View {
        VStack(spacing: 0) {
            Divider().background(Color.dividerSB)
            
            HStack(alignment: .center) {
                ForEach(Array(emoticons.enumerated()), id: \.offset) { index, emoji in
                    Button {
                        text += emoji
                    } label: {
                        Text(emoji)
                            .font(.system(size: 24))
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                    
                    if index < emoticons.count - 1 {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            
            HStack(spacing: 12) {
                AvatarView(
                    imageURL: nil,
                    size: .xs,
                    border: nil
                )
                
                TextField("Adaugă un comentariu...", text: $text, axis: .vertical)
                    .font(.body)
                    .lineLimit(1...4)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Button {
                    guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    onCreateComment(text, parentId)
                    text = ""
                    parentId = nil
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(text.isEmpty ? .gray.opacity(0.5) : .blue)
                }
                .disabled(text.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
        }
    }
}
