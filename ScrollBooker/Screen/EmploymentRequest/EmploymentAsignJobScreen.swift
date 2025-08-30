//
//  EmploymentAsignJobScreen\.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentAsignJobScreen: View {
    var body: some View {
        Header(title: "")
        
        FormLayout(
            headline: String(localized: "assignJob"),
            subHeadline: String(localized: "chooseProfessionsFromTheList"),
            buttonTitle: String(localized: "next")
        ) {
            
        }
    }
}

#Preview("Light") {
    EmploymentAsignJobScreen()
}

#Preview("Dark") {
    EmploymentAsignJobScreen()
}

