//
//  CommentFooterView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

struct CommentFooterView: View {
    let placeholder: String
    // SOLUȚIA PENTRU FOCUS: Primim un ID unic care se schimbă la fiecare tap pe Reply
    let replyTrigger: Int?
    let isReplyActive: Bool

    var onCreateComment: (String) -> Void
    var onCancelReply: (() -> Void)? = nil
    
    // Sursa de adevăr pentru focusul tastaturii native
    @FocusState private var isTextFieldFocused: Bool
    
    private let emoticons = ["👌", "😁", "😇", "🤣", "😍", "🥰"]
    @State private var text: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Linie despărțitoare superioară subțire
            Divider()
                .background(Color.dividerSB)
            
            // 1. Rândul de Emoji-uri distribuit în mod egal pe tot width-ul ecranului
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
            
            // 2. Câmpul de introducere text expandabil și butoanele de acțiune
            HStack(spacing: 12) {
                AvatarView(
                    imageURL: nil,
                    size: .xs,
                    border: nil
                )
                
                TextField(placeholder, text: $text, axis: .vertical)
                    .font(.body)
                    .lineLimit(1...4) // Crește fluid în jos până la 4 rânduri ca pe Instagram
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    // Legăm TextField-ul de starea de focus controlată de sistem
                    .focused($isTextFieldFocused)
                
                Button {
                    guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    
                    // Ascundem tastatura instantaneu la trimitere pentru un flow vizual curat
                    isTextFieldFocused = false
                    
                    onCreateComment(text)
                    text = "" // Resetăm textul local din casetă
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(text.isEmpty ? .gray.opacity(0.5) : .blue)
                }
                .disabled(text.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemBackground)) // Fundal solid pentru a izola elementele de lista din spate
        }
        .onChange(of: text) { _, newValue in
            // Dacă textul este șters complet de utilizator și modul Reply era activ, anulăm eticheta
            if newValue.isEmpty && isReplyActive {
                onCancelReply?()
            }
        }
        // SOLUȚIA PENTRU BUG-UL DE LAG ȘI BLOCARE KEYBOARD:
        // Ascultăm modificările valorii unice de ID. Chiar dacă este același comentariu selectat consecutiv,
        // re-evaluarea stării va ridica tastatura de fiecare dată fără excepție.
        .onChange(of: replyTrigger) { _, newValue in
            if newValue != nil {
                // Adăugăm un delay calibrat (0.1s) pentru a asigura că animațiile interne ale
                // BottomSheet-ului s-au stabilizat pe firul principal înainte de a forța focusul
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTextFieldFocused = true
                }
            }
        }
    }
}

