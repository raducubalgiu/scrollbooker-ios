//
//  EmploymentSelectEmployeeScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentSelectEmployeeScreen: View {
    var body: some View {
        Header(title: "")
        
        FormLayout(
            headline: String(localized: "selectEmployee"),
            subHeadline: String(localized: "searchEmployeeAndSelectToContinue"),
            buttonTitle: String(localized: "next")
        ) {
            
        }
    }
}

#Preview("Light") {
    EmploymentSelectEmployeeScreen()
}

#Preview("Dark") {
    EmploymentSelectEmployeeScreen()
        .preferredColorScheme(.dark)
}
