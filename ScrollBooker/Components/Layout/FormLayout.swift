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
        VStack(spacing: 0) {
            if enableBack {
                HeaderView(
                    enableBack: true,
                    onBack: onBack
                )
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(headline)
                    .font(.largeTitle.bold())
                    .padding(.bottom, .xxs)
                    .padding(.horizontal, .xl)
                
                Text(subHeadline)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                    .padding(.horizontal, .xl)
                
                content()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.top, .base)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if enableBottomButton {
                    VStack(spacing: 0) {
                        MainButton(
                            title: buttonTitle,
                            isDisabled: isDisabled,
                            isLoading: isLoading,
                            onClick: onClick
                        )
                    }
                    .padding(.horizontal, .xl)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    .background(
                        Color.backgroundSB
                            .ignoresSafeArea(edges: .bottom)
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundSB)
    }
}
