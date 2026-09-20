//
//  ToastOverlayView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.09.2026.
//

import SwiftUI

struct ToastOverlayView: View {
    let toast: ToastMessage?

    var body: some View {
        VStack {
            if let toast {
                HStack(spacing: AppSize.s.rawValue) {
                    Image(systemName: toast.type == .error ? "xmark.circle.fill" : "checkmark.circle.fill")

                    Text(toast.message)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                }
                .foregroundColor(toast.type == .error ? .onErrorSB : .backgroundSB)
                .padding(.horizontal, .base)
                .padding(.vertical, .m)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(toast.type == .error ? Color.errorSB : Color.onBackgroundSB)
                )
                .padding(.horizontal, .base)
                .id(toast.id)
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            Spacer()
        }
        .padding(.top, .s)
        .animation(.easeInOut(duration: 0.25), value: toast)
        .allowsHitTesting(false)
    }
}
