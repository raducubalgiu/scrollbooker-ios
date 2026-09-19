//
//  PlaceholderActionBoxView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.09.2026.
//

import SwiftUI

struct PlaceholderActionBoxView: View {
    let description: String
    var icon: String? = "plus"
    var isError: Bool = false
    var errorMessage: String = ""
    var onClick: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                onClick?()
            } label: {
                VStack(spacing: AppSize.m.rawValue) {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(isError ? .errorSB : .onSurfaceSB)
                    }

                    Text(description)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(isError ? .errorSB : .onSurfaceSB)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, AppSize.xl.rawValue)
                .padding(.vertical, AppSize.xxl.rawValue)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.onSurfaceSB.opacity(0.03))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            isError ? Color.errorSB : Color.gray.opacity(0.5),
                            style: StrokeStyle(lineWidth: 1.5, dash: [6, 6])
                        )
                )
            }
            .buttonStyle(.plain)
            .disabled(onClick == nil)

            if isError {
                HStack(spacing: AppSize.xs.rawValue) {
                    Image(systemName: "exclamationmark.triangle")
                    Text(errorMessage)
                }
                .font(.footnote)
                .foregroundColor(.errorSB)
                .padding(.top, .s)
            }
        }
    }
}
