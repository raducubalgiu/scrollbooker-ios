//
//  UserProfileHeader.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct UserProfileHeader: View {
    var username: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.onBackgroundSB)
                    .font(.system(size: 24))
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Text(username)
                .font(.headline.bold())
            
            Spacer()
            
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.backgroundSB)
                .font(.system(size: 24))

        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("Light") {
    UserProfileHeader(username: "radu_balgiu")
}

#Preview("Dark") {
    UserProfileHeader(username: "radu_balgiu")
        .preferredColorScheme(.dark)
}
