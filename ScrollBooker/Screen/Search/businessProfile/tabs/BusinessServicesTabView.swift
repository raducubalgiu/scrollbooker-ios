//
//  BusinessServicesTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessServicesTabView: View {
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<5, id: \.self) { i in
                HStack {
                    VStack(alignment: .leading) {
                        Text("Tuns Classic \(i+1)")
                            .font(.body.weight(.semibold))
                        HStack {
                            Text("45 min")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("Femei")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Text("85 RON")
                            .font(.body.weight(.bold))
                            .padding(.top, .xs)
                    }
                    
                    Spacer()
                    
                    MainButtonOutlined(
                        title: String(localized: "book"),
                        onClick: {}
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, .s)
                .padding(.horizontal, .base)
                
                Divider()
            }
            
            MainButtonOutlined(
                title: String(localized: "seeMore"),
                fullWidth: true,
                paddingV: 17.5,
                onClick: {}
            )
            .padding()
        }
    }
}

#Preview("Light") {
    BusinessServicesTabView()
}

#Preview("Dark") {
    BusinessServicesTabView()
        .preferredColorScheme(.dark)
}
