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
            Text("services")
                .font(.title2.weight(.heavy))
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: .infinity, alignment: .leading)
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
