//
//  CheckboxView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.09.2025.
//

import SwiftUI

struct CheckboxView: View {
    var checked: Bool = false
    var onChange: () -> Void
    var width: CGFloat = 20
    var height: CGFloat = 20
    
    var body: some View {
        Button(action: onChange) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(Color.gray.opacity(0.6), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(checked ? Color.primarySB : Color.clear)
                    )
                    .frame(width: width, height: height)
                
                if checked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(checked ? "Bifat" : "Nebifat")
    }
}

#Preview("Light") {
    CheckboxView(
        checked: true, onChange: {}
    )
}

#Preview("Dark") {
    CheckboxView(
        checked: true, onChange: {}
    )
    .preferredColorScheme(.dark)
}
