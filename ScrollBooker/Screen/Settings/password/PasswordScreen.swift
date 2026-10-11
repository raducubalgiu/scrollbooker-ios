//
//  PasswordScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct PasswordScreen: View {
    var onBack: () -> Void
    
    var body: some View {
        HeaderView(onBack: onBack)
    }
}
