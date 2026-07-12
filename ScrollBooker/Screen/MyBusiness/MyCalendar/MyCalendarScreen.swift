//
//  MyCalendarScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct MyCalendarScreen: View {
    var onBack: () -> Void
    
    var body: some View {
        HeaderView(
            title: String(localized: "myCalendar"),
            onBack: onBack
        )
        
        Spacer()
    }
}
