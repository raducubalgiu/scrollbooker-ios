//
//  ProfileActionsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct ProfileActionsView: View {
    var onNavigateToEditProfile: () -> Void
    
    var body: some View {
        HStack {
            Button {
                onNavigateToEditProfile()
            } label: {
                Text("Editeaza profilul")
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .fontWeight(.semibold)
            .foregroundColor(Color.onSurfaceSB)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.surfaceSB)
            )
            
            Button {
                
            }
            label: {
                HStack {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .fontWeight(.semibold)
            .foregroundColor(Color.onSurfaceSB)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.surfaceSB)
            )
        }
        .padding(.vertical, .xs)
    }
}

#Preview {
    ProfileActionsView(onNavigateToEditProfile: {})
}
