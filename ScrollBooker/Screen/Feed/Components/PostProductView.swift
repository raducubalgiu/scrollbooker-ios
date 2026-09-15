//
//  PostProductView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import SwiftUI

struct PostProductView: View {
    var product: PostProduct
    
    var body: some View {
        VStack {
            Divider()
                .background(.white)
                .padding(.vertical, .xxs)
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(product.name)
                        .font(.headline.bold())
                        .foregroundColor(.white)
                    
                    Text("\(product.priceWithDiscount) \(product.currency.name)")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview("Dark") {
    PostProductView(
        product: PostProduct(
            id: 1,
            name: "Tuns Special",
            description: "Acesta descriere este una dummy facuta special pentru acest produs",
            duration: 60,
            price: 150,
            priceWithDiscount: 75,
            discount: 50,
            currency: PostProductCurrency(id: 1, name: "RON")
        )
    )
    .preferredColorScheme(.dark)
}
