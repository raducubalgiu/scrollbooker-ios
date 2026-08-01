//
//  ProfileAboutOwnerSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import SwiftUI

struct ProfileAboutOwnerSectionView: View {
    let owner: UserProfileAboutOwner
    let onNavigateToUserProfile: (Int, String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ANGAJAT LA")
                .font(.caption)
                .fontWeight(.bold)
                .kerning(1.2)
                .foregroundColor(.primary.opacity(0.8))
            
            HStack(spacing: 16) {
                Group {
                    if let avatar = owner.avatar, !avatar.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, let url = URL(string: avatar) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "building.2.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 56, height: 56)
                .background(Color.surfaceSB)
                .cornerRadius(12)
                .clipped()
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(owner.fullName)
                        .font(.body)
                        .fontWeight(.black)
                        .lineLimit(1)
                    
                    Text(owner.profession)
                        .font(.subheadline)
                        .foregroundColor(.primary.opacity(0.7))
                        .lineLimit(1)
                }
                
                Spacer()
            }
            .padding(.bottom, 16)
            
            Button {
                onNavigateToUserProfile(owner.id, owner.username)
            } label: {
                HStack {
                    Spacer()
                    
                    Text("Vezi profilul business-ului")
                        .font(.body)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}
