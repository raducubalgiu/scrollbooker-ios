//
//  BusinessSocialTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessSocialTabView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("social")
                .font(.title2.weight(.heavy))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(0...20, id: \.self) { index in
                        
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Light") {
    BusinessSocialTabView()
}

#Preview("Dark") {
    BusinessSocialTabView()
        .preferredColorScheme(.dark)
}
