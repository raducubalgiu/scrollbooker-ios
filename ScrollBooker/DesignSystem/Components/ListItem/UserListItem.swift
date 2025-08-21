//
//  UserListItem.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct UserListItem: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Radu Balgiu")
                Text("@radu_balgiu")
            }
            
            Button {
                
            } label: {
                Text("Urmareste")
            }
        }
        .frame(maxWidth: .infinity)
        .background(.red)
    }
}

#Preview {
    UserListItem()
}
