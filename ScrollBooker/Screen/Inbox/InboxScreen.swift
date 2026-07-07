//
//  InboxScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct InboxScreen: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Header(
                    title: String(localized: "inbox"),
                    enableBack: false
                )
            }
        }
    }
}

//#Preview("Light") {
//    InboxScreen(
//        //onNavigateToEmployment: {}
//    )
//}
//
//#Preview("Dark") {
//    InboxScreen(
//        //onNavigateToEmployment: {}
//    )
//        .preferredColorScheme(.dark)
//}
