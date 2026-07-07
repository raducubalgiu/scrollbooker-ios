//
//  EditGenderScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct EditGenderScreen: View {
    var body: some View {
        Header(title: String(localized: "gender"))
        
        Spacer()
    }
}

#Preview("Light") {
    EditGenderScreen()
    
    Spacer()
}

#Preview("Dark") {
    EditGenderScreen()
        .preferredColorScheme(.dark)
    
    Spacer()
}
