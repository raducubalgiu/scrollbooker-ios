//
//  EditBirthdateScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.07.2026.
//

import SwiftUI

struct EditBirthdateScreen: View {
    var body: some View {
        Header(title: String(localized: "birthdate"))
        
        Spacer()
    }
}

#Preview("Light") {
    EditBirthdateScreen()
    
    Spacer()
}

#Preview("Dark") {
    EditBirthdateScreen()
        .preferredColorScheme(.dark)
    
    Spacer()
}

