//
//  ProfileDescriptionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct ProfileDescriptionView: View {
    var description: String = ""
    
    var body: some View {
        Text(description)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    }
}

#Preview {
    ProfileDescriptionView(
        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been."
    )
}
