//
//  InboxScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct InboxScreen: View {
    var body: some View {
        Header(
            title: String(localized: "inbox"),
            enableBack: false
        )
        
        Spacer()
    }
}

#Preview("Light") {
    InboxScreen()
}

#Preview("Dark") {
    InboxScreen()
        .preferredColorScheme(.dark)
}
