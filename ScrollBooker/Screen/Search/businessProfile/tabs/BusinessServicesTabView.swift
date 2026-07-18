//
//  BusinessServicesTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessServicesTabView: View {
    let products: UserProducts
    
    var body: some View {
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
        }
    }
}
