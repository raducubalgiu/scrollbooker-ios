//
//  OpeningHoursSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.09.2025.
//

import SwiftUI

struct OpeningHoursSheetView: View {
    @State private var measuredHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    Text("Luni")
                        .font(.headline)
                }
                
                Spacer()
                
                Text("09:00 - 18:00")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    Text("Marti")
                        .font(.headline)
                }
                
                Spacer()
                
                Text("09:00 - 18:00")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { measuredHeight = geo.size.height }
                    .onChange(of: geo.size.height) { _, new in
                        measuredHeight = new
                    }
            }
        )
        .presentationDetents([.height(max(100, measuredHeight + 16))])
        .presentationContentInteraction(.resizes)
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

