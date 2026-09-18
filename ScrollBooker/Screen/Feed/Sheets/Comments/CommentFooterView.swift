//
//  CommentFooterView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct CommentFooterView: View {
    let placeholder: String
    let replyTrigger: Int?
    let isReplyActive: Bool

    var onCreateComment: (String) -> Void
    var onCancelReply: (() -> Void)? = nil
    
    @FocusState private var isTextFieldFocused: Bool
    
    private let emoticons = ["👌", "😁", "😇", "🤣", "😍", "🥰"]
    @State private var text: String = ""

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.dividerSB)
            
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
                
                TextField(placeholder, text: $text, axis: .vertical)
                    .font(.body)
                    .lineLimit(1...4)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .focused($isTextFieldFocused)
                
                Button {
                    guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    
                    isTextFieldFocused = false
                    
                    onCreateComment(text)
                    text = ""
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
        .onChange(of: text) { _, newValue in
            if newValue.isEmpty && isReplyActive {
                onCancelReply?()
            }
        }
        .onChange(of: replyTrigger) { _, newValue in
            if newValue != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTextFieldFocused = true
                }
            }
        }
    }
}

