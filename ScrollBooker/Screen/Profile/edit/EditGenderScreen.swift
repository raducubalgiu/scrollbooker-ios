//
//  EditGenderScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct EditGenderScreen: View {
    var onBack: () -> Void
    
    var body: some View {
        HeaderView(
            title: String(localized: "gender"),
            onBack: onBack
        )
        
        Spacer()
    }
}

#Preview("Light") {
    EditGenderScreen(
        onBack: {}
    )
    
    Spacer()
}

#Preview("Dark") {
    EditGenderScreen(
        onBack: {}
    )
        .preferredColorScheme(.dark)
    
    Spacer()
}
