//
//  ProfileHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI

struct MyProfileHeaderView: View {
    var username: String
    var onOpenMenuSheet: () -> Void
    var onNavigateToCamera: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(username)
                .font(.headline.bold())
            
            Spacer()
            
            HStack(spacing: 16) {
                Button {
                    onNavigateToCamera()
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.onBackgroundSB)
                        .font(.system(size: 24))
                }
                .buttonStyle(.plain)
                
                Button {
                    onOpenMenuSheet()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.onBackgroundSB)
                        .font(.system(size: 24))
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
