//
//  CollectBusinessHasEmployeesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct CollectBusinessHasEmployeesScreen: View {
    var body: some View {
        FormLayout(
            headline: "Ai angajati care primesc programari?",
            subHeadline: "",
            buttonTitle: "Pasul urmator",
        ) {
            Text(
                "Daca da, fiecare angajat va avea propriul calendar si isi va gestiona propriile produse separat."
            )
            .foregroundColor(.gray)
            .padding(.bottom, .base)
            
            Text(
                "Daca nu, toate programarile vor fi gestionate direct in numele business-ului tau, intr-un singur calendar"
            )
            .foregroundColor(.gray)
            .padding(.bottom, .base)
            
            Divider()
        }
    }
}

#Preview("Light") {
    CollectBusinessHasEmployeesScreen()
}

#Preview("Dark") {
    CollectBusinessHasEmployeesScreen()
        .preferredColorScheme(.dark)
}
