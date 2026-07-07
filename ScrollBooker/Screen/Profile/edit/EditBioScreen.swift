//
//  EditBioScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct EditBioScreen: View {
    var body: some View {
        Header(title: String(localized: "biography"))
        
        Spacer()
    }
}

#Preview("Light") {
    EditBioScreen()
    
    Spacer()
}

#Preview("Dark") {
    EditBioScreen()
        .preferredColorScheme(.dark)
    
    Spacer()
}
