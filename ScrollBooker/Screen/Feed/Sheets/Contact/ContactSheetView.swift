//
//  ContactSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.10.2026.
//

import SwiftUI

struct ContactSheetView: View {
    var onWriteOnWhatsApp: () -> Void = {}
    var onCall: () -> Void = {}

    @Environment(\.dismiss) private var dismiss
    @State private var measuredHeight: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(
                onDismiss: { dismiss() },
                title: String(localized: "contactUs")
            )

            VStack(spacing: 0) {
                ListItemView(
                    title: String(localized: "writeOnWhatsApp"),
                    leadingIcon: "message",
                    onClick: {
                        onWriteOnWhatsApp()
                        dismiss()
                    },
                    showTrailingIcon: false
                )

                ListItemView(
                    title: String(localized: "call"),
                    leadingIcon: "phone",
                    onClick: {
                        onCall()
                        dismiss()
                    },
                    showTrailingIcon: false
                )
            }
            .padding(.horizontal)
            .padding(.top, .s)
            .padding(.bottom)
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { measuredHeight = geo.size.height }
                    .onChange(of: geo.size.height) { _, new in
                        measuredHeight = new
                    }
            }
        )
        .presentationDetents([.height(max(100, measuredHeight))])
        .presentationContentInteraction(.resizes)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(25)
    }
}
