//
//  EditBirthdateScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.07.2026.
//

import SwiftUI

struct EditBirthdateScreen: View {
    var onBack: () -> Void
    
    var body: some View {
        HeaderView(
            title: String(localized: "birthdate"),
            onBack: onBack
        )
        
        Spacer()
    }
}
