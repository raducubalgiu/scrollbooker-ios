//
//  ProfileCountersView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI

struct ProfileCountersView: View {
    var body: some View {
        HStack {
            ProfileCounterView(counter: 100, label: "Recenzii")
            
            VerticalDivider(height: 25)
                .padding(.horizontal, .m)
            
            ProfileCounterView(counter: 1500, label: "Urmaritori")
            
            VerticalDivider(height: 25)
                .padding(.horizontal, .m)
            
            ProfileCounterView(counter: 15, label: "Urmaresti")
        }
    }
}

#Preview("Light") {
    ProfileCountersView()
}

#Preview("Dark") {
    ProfileCountersView()
        .preferredColorScheme(.dark)
}

