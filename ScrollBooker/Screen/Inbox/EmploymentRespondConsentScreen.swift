//
//  EmploymentRespondConsentScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentRespondConsentScreen: View {
    var body: some View {
        Header(title: String(localized: "termsAndConditions"))
        
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Terms from BEsfdfefefefefefefefefefefefefefefefefefefefefeffefef")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                    Text("Terms from BE")
                }
            }
            
            MainButton(
                title: String(localized: "accept"),
                onClick: {})
        }
        .padding(.horizontal)
    }
}

#Preview("Light") {
    EmploymentRespondConsentScreen()
}

#Preview("Dark") {
    EmploymentRespondConsentScreen()
        .preferredColorScheme(.dark)
}
