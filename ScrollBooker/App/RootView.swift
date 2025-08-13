//
//  RootView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.08.2025.
//

import SwiftUI

struct RootView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        FormLayout(
            headline: "Logare",
            subHeadline: "Please login to continue",
            enableBottomButton: false,
        ) {
            Input(
                label: "Email",
                text: $email,
                placeholder: "Email",
                keyboardType: .emailAddress,
            )
            
            Input(
                label: "Parola",
                text: $password,
                placeholder: "Parola",
                keyboardType: .emailAddress,
            )
            
            MainButton(
                title: "Logare",
                onClick: {  }
            )
            
            HStack {
                Text("Nu ai inca un cont?")
                Button("Inregistrare") {
                    
                }
                .foregroundColor(.primarySB)
                .fontWeight(.bold)
            }
            
            VStack {
                Spacer()
                
                Divider()
                
                Text("Ai un business care primeste programari?")
                    .padding(.vertical)
                
                MainButtonOutlined(
                    title: "Inregistreaza",
                    onClick: {}
                )
            }
        }
    }
}

#Preview("Light") {
    RootView()
}

#Preview("Dark") {
    RootView()
        .applyPreferredColorScheme(.dark)
}
