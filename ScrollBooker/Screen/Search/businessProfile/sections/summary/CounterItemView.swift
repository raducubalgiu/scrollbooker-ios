//
//  CounterItemView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.07.2026.
//

import SwiftUI

struct CounterItemView: View {
    let counter: Int?
    let label: String
    let onNavigate: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: AppSize.xs.rawValue) {
            Text(counter != nil ? "\(counter!)" : "-")
                .font(.subheadline.bold())
                .foregroundColor(.onBackgroundSB)
            
            Text(label)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            onNavigate()
        }
    }
}
