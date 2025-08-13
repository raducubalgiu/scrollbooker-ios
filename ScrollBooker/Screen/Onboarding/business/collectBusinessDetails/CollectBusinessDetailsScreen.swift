//
//  CollectBusinessDetailsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectBusinessDetailsScreen: View {
    @State private var name: String = ""
    @State private var description: String = ""
    
    var body: some View {
        FormLayout(
            headline: "Prezentarea locatiei",
            subHeadline: "Spune-ne cum se numeste business-ul tau si ofera cateva detalii despre servicii sau orice crezi ca este important",
            buttonTitle: "Pasul urmator",
        ) {
            
            VStack(alignment: .leading) {
                InputEdit(
                    text: $name,
                    placeholder: "Numele business-ului tau",
                    label: "Nume*",
                    onClear: { name = "" }
                )
                .padding(.bottom, .xl)
                
                Textarea(
                    text: $description,
                    label: "Descriere",
                    placeholder: "Adauga o descriere",
                )
            }
        }
    }
}

#Preview("Light") {
    CollectBusinessDetailsScreen()
}

#Preview("Dark") {
    CollectBusinessDetailsScreen()
        .preferredColorScheme(.dark)
}
