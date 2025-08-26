//
//  ReportProblemScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct ReportProblemScreen: View {
    @State private var text: String = ""
    
    var body: some View {
        Header(title: "Raporteaza o problema")
        
        VStack {
            Textarea(
                text: $text,
                label: "",
                placeholder: "Raporteaza o problema",
                height: 150
            )
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
    }
}

#Preview("Light") {
    ReportProblemScreen()
}

#Preview("Dark") {
    ReportProblemScreen()
        .preferredColorScheme(.dark)
}
