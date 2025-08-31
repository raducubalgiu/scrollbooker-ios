//
//  ProfileLayout.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfileLayout<Header: View, Actions: View>: View {
    var user: UserProfile
    
    @State private var showBottomSheet = false
    @State private var showOpeningHoursSheet = false
    @State private var measuredHeight: CGFloat = 0
    
    @ViewBuilder var header: () -> Header
    @ViewBuilder var actions: () -> Actions
    
    var body: some View {
        header()
        
        VStack(spacing: 12) {
            ProfileCountersView(
                counters: user.counters,
                onNavigateToUserSocial: {}
            )
            .padding(.vertical, .xl)
            
            ProfileUserInfoView(
                url: user.avatarURL,
                fullName: user.fullName,
                profession: user.profession,
                isBusinessOrEmployee: user.isBusinessOrEmployee,
                ratingsAverage: user.counters.ratingsAverage,
                openingHours: user.openingHours,
                onShowOpeningHoursSheet: { showOpeningHoursSheet = true }
            )
            
            actions()
            
            if let owner = user.businessOwner {
                HStack {
                    Image(systemName: "repeat")
                    AvatarView(
                        imageURL: URL(string: "https://media.scrollbooker.ro/avatar-male-9.jpeg"),
                        size: .s
                    )
                    Text(owner.fullName)
                        .font(.headline)
                }
            }
            
            ProfileContactView()
            
            if let description = user.bio {
                ProfileDescriptionView(description: description)
            }
            
            ProfileTabView()
        }
        .sheet(isPresented: $showOpeningHoursSheet) {
            VStack {
                Text("Opening Hours Sheet")
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
                        
                    },
                    showTrailingIcon: false
                )
                .padding(.horizontal)
                
                ListItemView(
                    title: "Setari",
                    leadingIcon: "gearshape",
                    onClick: {
                        showBottomSheet = false
                        
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
    }
}

//#Preview("Light") {
//    ProfileLayout()
//}
//
//#Preview("Dark") {
//    ProfileLayout()
//}
