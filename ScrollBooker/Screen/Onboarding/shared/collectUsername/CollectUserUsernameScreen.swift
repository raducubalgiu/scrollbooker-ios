//
//  CollectUserUsernameScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectUserUsernameScreen: View {
    @State private var username: String = ""
    
    var body: some View {
        FormLayout(
            headline: "Nume de utilizator",
            subHeadline: "Alege un nume unic pentru profilul tau. Poti alege orice varianta disponibila",
            enableBottomButton: false,
            buttonTitle: "",
        ) {
            Input(
                text: $username,
                placeholder: "Nume de utilizator",
                leadingIcon: Image(systemName: "at"),
            )
            
            MainButton(
                title: "Salveaza",
                onClick: {},
                isDisabled: true
            )
        }
    }
}

#Preview("Light") {
    CollectUserUsernameScreen()
}

#Preview("Dark") {
    CollectUserUsernameScreen()
        .preferredColorScheme(.dark)
}

