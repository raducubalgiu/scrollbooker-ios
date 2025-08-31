//
//  ProfileContactView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct ProfileContactView: View {
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "paperplane")
                    .foregroundColor(.primarySB)
                Text("Email")
                    .font(.headline)
            }
            
            VerticalDivider(height: 10)
            
            HStack {
                Image(systemName: "paperplane")
                    .foregroundColor(.primarySB)
                Text("Adresa")
                    .font(.headline)
            }
            
            VerticalDivider(height: 10)
            
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.primarySB)
                Text("Website")
                    .font(.headline)
            }
        }
    }
}

#Preview {
    ProfileContactView()
}
