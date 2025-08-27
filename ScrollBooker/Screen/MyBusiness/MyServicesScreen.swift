//
//  MyServicesScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct MyServicesScreen: View {
    var body: some View {
        //Header(title: "Serviciile mele")
        
        FormLayout(
            headline: "Serviciile mele",
            subHeadline: "Adauga serviciile pe care le desfasori la activitate",
            enableBack: true,
            buttonTitle: "Salveaza"
        ) {
            
        }
    }
}

#Preview {
    MyServicesScreen()
}
