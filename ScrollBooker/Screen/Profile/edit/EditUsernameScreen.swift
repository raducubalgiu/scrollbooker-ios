//
//  EditUsernameScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct EditUsernameScreen: View {
    var onBack: () -> Void
    
    var body: some View {
        HeaderView(
            title: "Username",
            onBack: onBack
        )
        
        Spacer()
    }
}
