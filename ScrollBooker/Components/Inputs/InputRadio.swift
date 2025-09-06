//
//  InputRadio.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import SwiftUI

struct InputRadio: View {
    let title: String
    @Binding var isSelected: Bool
    var onClick: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                onClick()
            }
        }) {
            HStack {
                Text(title)
                    .foregroundColor(.onBackgroundSB)
                
                Spacer()
                
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.primarySB)
                            .frame(width: 25, height: 25)
                        
                        Circle()
                            .fill(Color.backgroundSB)
                            .frame(width: 10, height: 10)
                    } else {
                        Circle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            .frame(width: 25, height: 25)
                    }
                }
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview("Light") {
    VStack {
        InputRadio(
            title: "Some Title",
            isSelected: .constant(true),
            onClick: {}
        )
        
        InputRadio(
            title: "Some Title",
            isSelected: .constant(false),
            onClick: {}
        )
    }
    .padding()
}

#Preview("Dark") {
    VStack {
        InputRadio(
            title: "Some Title",
            isSelected: .constant(true),
            onClick: {}
        )
        .preferredColorScheme(.dark)
        
        InputRadio(
            title: "Some Title",
            isSelected: .constant(false),
            onClick: {}
        )
        .preferredColorScheme(.dark)
    }
    .padding()
}
