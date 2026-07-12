//
//  EmploymentRespondConsentScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentRespondConsentScreen: View {
    var onBack: () -> Void
    
    var body: some View {
        HeaderView(
            title: String(localized: "termsAndConditions"),
            onBack: onBack
        )
        
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
    EmploymentRespondConsentScreen(
        onBack: {}
    )
}

#Preview("Dark") {
    EmploymentRespondConsentScreen(
        onBack: {}
    )
        .preferredColorScheme(.dark)
}
