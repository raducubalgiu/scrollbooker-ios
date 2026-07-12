//
//  EditProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct EditProfileScreen: View {
    let viewModel: MyProfileViewModel
    var onNavigate: (Route) -> Void
    var onBack: () -> Void
    
    var body: some View {
        VStack {
            HeaderView(
                title: String(localized: "editProfile"),
                onBack: onBack
            )
            
            VStack(alignment: .leading) {
                Text(String(localized: "aboutYou"))
                    .font(.subheadline.bold())
                    .foregroundColor(.gray)
                    .padding(.top, .base)
                
                Button {
                    onNavigate(.editFullName)
                } label: {
                    HStack {
                        Text(String(localized: "name"))
                            .font(.subheadline.bold())
                            .foregroundColor(.onBackgroundSB)
                        
                        Spacer()
                        
                        HStack {
                            Text(viewModel.profileController.uiState.data?.fullName ?? "")
                                .font(.subheadline.bold())
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, .m)
                }
                
                Button {
                    onNavigate(.editUsername)
                } label: {
                    HStack {
                        Text(String(localized: "username"))
                            .font(.subheadline.bold())
                            .foregroundColor(.onBackgroundSB)
                        
                        Spacer()
                        
                        HStack {
                            Text(viewModel.profileController.uiState.data?.username ?? "")
                                .font(.subheadline.bold())
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, .m)
                }
                
                Button {
                    onNavigate(.editBio)
                } label: {
                    HStack {
                        Text(String(localized: "biography"))
                            .font(.subheadline.bold())
                            .foregroundColor(.onBackgroundSB)
                        
                        Spacer()
                        
                        HStack {
                            Text(viewModel.profileController.uiState.data?.bio ?? "")
                                .font(.subheadline.bold())
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, .m)
                }
                
                Button {
                    onNavigate(.editGender)
                } label: {
                    HStack {
                        Text(String(localized: "gender"))
                            .font(.subheadline.bold())
                            .foregroundColor(.onBackgroundSB)
                        
                        Spacer()
                        
                        HStack {
                            Text("")
                                .font(.subheadline.bold())
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, .m)
                }
                
                Button {
                    onNavigate(.editBirthdate)
                } label: {
                    HStack {
                        Text(String(localized: "birthdate"))
                            .font(.subheadline.bold())
                            .foregroundColor(.onBackgroundSB)
                        
                        Spacer()
                        
                        HStack {
                            Text("")
                                .font(.subheadline.bold())
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, .m)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}
