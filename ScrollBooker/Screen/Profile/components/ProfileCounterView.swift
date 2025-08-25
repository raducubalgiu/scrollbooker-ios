//
//  CounterView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI

struct ProfileCounterView: View {
    var counter: Int? = 0
    var label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(counter != nil ? "\(counter!)" : "-")
                .font(.headline)
                .fontWeight(.bold)
            Text(label)
                .font(.subheadline)
        }
    }
}

#Preview {
    ProfileCounterView(label: "Recenzii")
}
