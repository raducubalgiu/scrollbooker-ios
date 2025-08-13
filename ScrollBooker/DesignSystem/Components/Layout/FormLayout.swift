//
//  FormLayout.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct FormLayout<Content: View>: View {
    var headline: String
    var subHeadline: String
    var enableBottomButton: Bool = true
    var buttonTitle: String = ""
    var onClick: (() -> Void) = {  }
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(headline)
                .font(.largeTitle.bold())
            
            Text(subHeadline)
                .font(.system(size: 19))
                .foregroundColor(.gray)
                .padding(.bottom)
            
            content()
            
            Spacer(minLength: 0)
            
            if enableBottomButton {
                MainButton(
                    title: buttonTitle,
                    onClick: onClick
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.top, .xl)
        .padding(.horizontal, .xl)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview("Light") {
    FormLayout(
        headline: "Logare",
        subHeadline: "Please login to continue",
        buttonTitle: "Login",
        onClick: {  }
    ) {
        Text("Some View")
    }
}

#Preview("Dark") {
    FormLayout(
        headline: "Logare",
        subHeadline: "Please login to continue",
        buttonTitle: "Login",
        onClick: {  }
    ) {
        Text("Some View")
    }
    .preferredColorScheme(.dark)
}
