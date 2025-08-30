//
//  EmploymentAcceptTermsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentAcceptTermsScreen: View {
    var body: some View {
        Header(title: "")
        
        FormLayout(
            headline: String(localized: "acceptTerms"),
            subHeadline: String(localized: "acceptTermsForFinishingEmployeeOnboarding"),
            buttonTitle: String(localized: "send")
        ) {
            ScrollView {
                VStack {
                    Text("Some Text")
                    Text("Some Text")
                    Text("Some Text")
                    Text("Some Text")
                    Text("Some Text")
                    Text("Some Text")
                    Text("Some Text")
                    Text("Some Text")
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.surfaceSB)
            )
            
            Text("acceptTermsAndConditions")
                .padding(.top, .m)
        }
    }
}

#Preview("Light") {
    EmploymentAcceptTermsScreen()
}

#Preview("Dark") {
    EmploymentAcceptTermsScreen()
        .preferredColorScheme(.dark)
}
