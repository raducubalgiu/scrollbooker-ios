//
//  BusinessAboutTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessAboutTabView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Program")
                .font(.title3.weight(.bold))
            Text("Lu–Vi 09:00–20:00\nSâ 10:00–18:00\nDu închis")

            Text("Adresă")
                .font(.title3.weight(.bold))
                .padding(.top, 8)
            Text("Calea Victoriei 10, București")

            Spacer(minLength: 12)
        }
        .padding(16)
        .background(Color(.systemBackground))
    }
}

#Preview("Light") {
    BusinessAboutTabView()
}

#Preview("Dark") {
    BusinessAboutTabView()
        .preferredColorScheme(.dark)
}
