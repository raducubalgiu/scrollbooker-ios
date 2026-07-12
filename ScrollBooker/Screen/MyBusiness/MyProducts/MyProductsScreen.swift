//
//  MyProductsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct MyProductsScreen: View {
    var onBack: () -> Void
    
    var body: some View {
        HeaderView(
            title: "Produsele mele",
            onBack: onBack
        )
        
        Spacer()
    }
}

#Preview {
    MyProductsScreen(
        onBack: {}
    )
}
