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
    var enableBack: Bool = false
    var buttonTitle: String = ""
    
    var isDisabled: Bool = false
    var isLoading: Bool = false
    
    var onBack: () -> Void
    var onClick: (() -> Void) = {  }
    
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack {
            if(enableBack) {
                HeaderView(
                    enableBack: true,
                    onBack: onBack
                )
            }
            
            VStack(alignment: .leading) {
                Text(headline)
                    .font(.largeTitle.bold())
                    .padding(.bottom, .xxs)
                
                Text(subHeadline)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                content()
                
                Spacer(minLength: 0)
                
                if enableBottomButton {
                    MainButton(
                        title: buttonTitle,
                        isDisabled: isDisabled,
                        isLoading: isLoading,
                        onClick: onClick,
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.top, .base)
            .padding(.horizontal, .xl)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundSB)
    }
}
