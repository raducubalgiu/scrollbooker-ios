//
//  AccountInfoScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct AccountInfoScreen: View {
    var onBack: () -> Void
    
    var body: some View {
        HeaderView(onBack: onBack)
    }
}
