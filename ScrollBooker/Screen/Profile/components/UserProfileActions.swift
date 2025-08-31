//
//  UserProfileActions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct UserProfileActions: View {
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Text("follow")
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .fontWeight(.semibold)
            .foregroundColor(Color.onPrimarySB)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.primarySB)
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
            
            Button {
                
            }
            label: {
                Image(systemName: "arrowtriangle.down.fill")
                    .foregroundColor(.onSurfaceSB)
            }
            .frame(height: 50)
            .frame(width: 50)
            .fontWeight(.semibold)
            .foregroundColor(Color.onSurfaceSB)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.surfaceSB)
            )
        }
        .padding(.horizontal)
    }
}

#Preview("Light") {
    UserProfileActions()
}

#Preview("Dark") {
    UserProfileActions()
        .preferredColorScheme(.dark)
}
