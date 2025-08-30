//
//  EmploymentRequestsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentsScreen: View {
    var body: some View {
        Header(title: String(localized: "employmentRequests"))
        
        Text("Employments Screen")
        
        Spacer()
    }
}

#Preview("Light") {
    EmploymentsScreen()
}

#Preview("Dark") {
    EmploymentsScreen()
        .preferredColorScheme(.dark)
}
