//
//  InputCheckbox.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct InputCheckbox: View {
    let headLine: String
    let checked: Bool
    var onCheckedChange: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                onCheckedChange()
            }
        }) {
            HStack {
                Text(headLine)
                    .foregroundColor(.onBackgroundSB)
                    .font(.body)
                
                Spacer()
                
                ZStack {
                    if checked {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.primarySB)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
