//
//  OpeningHoursSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.09.2025.
//

import SwiftUI

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct OpeningHoursSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var contentHeight: CGFloat = 300
    
    var body: some View {
        VStack(spacing: 16) {
            SheetHeaderView(
                onDismiss: { dismiss() },
                title: String(localized: "schedule")
            )
            
            VStack {
                ForEach(["Luni", "Marți", "Miercuri", "Joi", "Vineri", "Sâmbătă", "Duminică"], id: \.self) { zi in
                    HStack {
                        HStack {
                            Circle().fill(Color.green).frame(width: 10, height: 10)
                            Text(zi).font(.headline)
                        }
                        Spacer()
                        Text("09:00 - 18:00").font(.headline)
                    }
                }
            }.padding()
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: ViewHeightKey.self, value: geo.size.height)
            }
        )
        .onPreferenceChange(ViewHeightKey.self) { newValue in
            if newValue > 0 {
                contentHeight = newValue
            }
        }
        .presentationDetents([.height(contentHeight + 16)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(25)
    }
}

#Preview("Light") {
    OpeningHoursSheetView()
}

#Preview("Dark") {
    OpeningHoursSheetView()
        .preferredColorScheme(.dark)
}

