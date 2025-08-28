//
//  MyProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct MyProfileScreen: View {
    @State private var showBottomSheet = false
    @State private var measuredHeight: CGFloat = 0
    
    var onNavigateToEditProfile: () -> Void
    var onNavigateToSettings: () -> Void
    var onNavigateToMyBusiness: () -> Void
    var onNavigateToUserSocial: () -> Void
    
    var body: some View {
        VStack {
            ProfileHeaderView(
                onShowBottomSheet: { showBottomSheet.toggle() },
                username: "@radu_balgiu",
            )
            
            ProfileCountersView(onNavigateToUserSocial: onNavigateToUserSocial)
                .padding(.vertical, .xxl)
            
            ProfileUserInfoView()
            
            ProfileActionsView(
                onNavigateToEditProfile: onNavigateToEditProfile
            )
            
            HStack {
                Image(systemName: "repeat")
                AvatarView(
                    imageURL: URL(string: "https://media.scrollbooker.ro/avatar-male-9.jpeg"),
                    size: .s
                )
                Text("Frizeria Figaro")
                    .font(.headline)
            }
            .padding(.vertical, .xs)
            
            ProfileContactView()
            
            ProfileDescriptionView(description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been.")
            
            Spacer()
        }
        .sheet(isPresented: $showBottomSheet) {
            VStack {
                ListItemView(
                    title: "Creaza o postare",
                    leadingIcon: "camera",
                    onClick: {},
                    showTrailingIcon: false
                )
                .padding(.horizontal)
                
                ListItemView(
                    title: "Afacerea mea",
                    leadingIcon: "bag",
                    onClick: {
                        showBottomSheet = false
                        onNavigateToMyBusiness()
                    },
                    showTrailingIcon: false
                )
                .padding(.horizontal)
                
                ListItemView(
                    title: "Setari",
                    leadingIcon: "gearshape",
                    onClick: {
                        showBottomSheet = false
                        onNavigateToSettings()
                    },
                    showTrailingIcon: false
                )
                .padding(.horizontal)
            }
            .padding(.top, .s)
            .padding(.bottom)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear { measuredHeight = geo.size.height }
                        .onChange(of: geo.size.height) { _, new in
                            measuredHeight = new
                        }
                }
            )
            .presentationDetents([.height(max(100, measuredHeight + 16))])
            .presentationContentInteraction(.resizes)
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(25)
        }
        .padding()
    }
}

#Preview("Light") {
    MyProfileScreen(
        onNavigateToEditProfile: {},
        onNavigateToSettings: {},
        onNavigateToMyBusiness: {},
        onNavigateToUserSocial: {}
    )
}

#Preview("Dark") {
    MyProfileScreen(
        onNavigateToEditProfile: {},
        onNavigateToSettings: {},
        onNavigateToMyBusiness: {},
        onNavigateToUserSocial: {}
    )
        .preferredColorScheme(.dark)
}
