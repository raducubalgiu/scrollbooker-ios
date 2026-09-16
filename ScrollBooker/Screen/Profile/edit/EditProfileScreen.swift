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

    @State private var showChoosePhotoSheet = false

    var body: some View {
        VStack {
            HeaderView(
                title: String(localized: "editProfile"),
                onBack: onBack
            )

            EditProfileAvatarView(
                avatarURL: viewModel.profileController.profile?.avatarURL,
                onClick: { showChoosePhotoSheet = true }
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
                            Text(viewModel.profileController.profile?.fullName ?? "")
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
                            Text(viewModel.profileController.profile?.username ?? "")
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
                            Text(viewModel.profileController.profile?.bio ?? "")
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
                        Text(String(localized: "dateOfBirth"))
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
        .sheet(isPresented: $showChoosePhotoSheet) {
            ChoosePhotoSheetView(onPickImage: { data in
                showChoosePhotoSheet = false
                viewModel.pickedAvatarData = data
                onNavigate(.editAvatarCrop)
            })
        }
    }
}
