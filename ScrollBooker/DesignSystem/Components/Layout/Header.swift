//
//  Header.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct Header: View {
    var title: String = ""
    var onBack: () -> Void
    
    var body: some View {
        HStack {
            Button {
                onBack()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22.5))
                    .foregroundColor(.onBackgroundSB)
            }
            .frame(width: 44, height: 44)
            
            Spacer()
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            VStack {  }.frame(width: 44, height: 44)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Light") {
    Header(
        title: "Header",
        onBack: {}
    )
    
    Spacer()
}

#Preview("Light") {
    Header(
        title: "Header",
        onBack: {}
    )
    .preferredColorScheme(.dark)
    
    Spacer()
}
