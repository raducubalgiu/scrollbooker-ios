//
//  CollectBusinessGalleryScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct CollectBusinessGalleryScreen: View {
    var body: some View {
        FormLayout(
            headline: "Galerie Foto",
            subHeadline: "Incarca cateva imagini de la locatie - o prezentare vizuala buna atrage mai multi clienti",
            buttonTitle: "Pasul urmator",
        ) {
            
        }
    }
}

#Preview("Light") {
    CollectBusinessGalleryScreen()
}

#Preview("Dark") {
    CollectBusinessGalleryScreen()
        .preferredColorScheme(.dark)
}
