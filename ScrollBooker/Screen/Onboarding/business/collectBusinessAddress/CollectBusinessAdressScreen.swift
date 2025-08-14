//
//  CollectBusinessAdressScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct CollectBusinessAdressScreen: View {
    @State private var searchText: String = ""
    
    var body: some View {
        FormLayout(
            headline: "Adresa locatiei",
            subHeadline: "Adauga adresa locatiei une vei primi clientii",
            buttonTitle: "Pasul urmator",
        ) {
            
        }
    }
}

#Preview("Light") {
    CollectBusinessAdressScreen()
}

#Preview("Dark") {
    CollectBusinessAdressScreen()
        .applyPreferredColorScheme(.dark)
}
