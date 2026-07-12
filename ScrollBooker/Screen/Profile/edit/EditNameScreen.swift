//
//  EditNameScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct EditNameScreen: View {
    var onBack: () -> Void
    
    var body: some View {
        HeaderView(
            title: String(localized: "name"),
            onBack: onBack
        )
        
        Spacer()
    }
}
