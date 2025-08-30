//
//  EmploymentRespondScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

let texts = [
    String(localized: "youWillReceiveAccessToYourOwnCalendarAndAppointments"),
    String(localized: "youWillBeAbleToEditAndAddServicesWithinYourBusiness"),
    String(localized: "clientsWillBeAbleToSelectYouDirectlyBasedYourAvailability"),
    String(localized: "youWillAppearInThePublicBusinessProfile"),
    String(localized: "youWillReceiveReviewsFromYourClients"),
    String(localized: "youCouldResignAnytime")
]

struct EmploymentRespondScreen: View {
    var body: some View {
        Header(title: "")
        
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .center, spacing: 25) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.primarySB)
                    Text("Frizeria Figaro ti-a trimis o cerere de angajare")
                }
                
                Text("hereIsWhatYouShouldNow")
                    .font(.headline.bold())
                    .padding(.top, .xl)
                    .padding(.bottom, .xxs)
                
                Text("byAcceptingThisRequest")
                    .padding(.bottom, .m)
                
                ForEach(texts, id: \.self) { text in
                    BulletListItem(text: text)
                }
            }
            .padding()
        }
        
        HStack {
            MainButton(
                title: String(localized: "deny"),
                onClick: {},
                bgColor: .surfaceSB,
                color: .onSurfaceSB
            )
            MainButton(title: String(localized: "accept"), onClick: {})
        }
        .padding(.horizontal)
    }
}

#Preview("Light") {
    EmploymentRespondScreen()
}

#Preview("Dark") {
    EmploymentRespondScreen()
        .preferredColorScheme(.dark)
}
