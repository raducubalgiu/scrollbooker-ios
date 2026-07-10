//
//  MainButton.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct MainButton: View {
    var title: String
    var onClick: () -> Void
    var isDisabled: Bool = false
    var isLoading: Bool = false
    var bgColor: Color = .primarySB
    var color: Color = .onPrimarySB
    
    var body: some View {
        Button(action: onClick) {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    Text(title)
                        .font(.subheadline.bold())
                }
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .contentShape(Rectangle())
        }
        .fontWeight(.semibold)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill((isDisabled || isLoading) ? Color.surfaceSB : bgColor)
        )
        .foregroundColor(isDisabled ? .gray : color)
        .padding(.vertical)
        .disabled(isDisabled || isLoading)
        .buttonStyle(.plain)
    }
}

#Preview("Light") {
    VStack(spacing: 0) {
        MainButton(
            title: "Contained",
            onClick: { }
        )
        
        MainButton(
            title: "Disabled",
            onClick: { },
            isDisabled: true
        )
        
        MainButton(
            title: "Loading",
            onClick: { },
            //isDisabled: true,
            isLoading: true
        )
    }
    .padding()
}

#Preview("Dark") {
    VStack(spacing: 0) {
        MainButton(
            title: "Contained",
            onClick: { }
        )
        
        MainButton(
            title: "Disabled",
            onClick: { },
            isDisabled: true
        )
        
        MainButton(
            title: "Loading",
            onClick: { },
            //isDisabled: true,
            isLoading: true
        )
    }
    .padding()
    .preferredColorScheme(.dark)
}

