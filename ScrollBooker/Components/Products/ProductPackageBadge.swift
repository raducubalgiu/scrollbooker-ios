//
//  ProductPackageBadge.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.07.2026.
//

import SwiftUI

struct ProductPackageBadge: View {
    let sessionsCount: Int?
    
    var body: some View {
        if let count = sessionsCount {
            Text("Pachet - \(count) ședințe")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Color.primarySB.opacity(0.12)
                )
                .cornerRadius(6)
        }
    }
}
