//
//  ProfileLayout.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfileLayout<Header: View, Actions: View>: View {
    var user: UserProfile
    var onNavigateToUserSocial: () -> Void
    
    @State private var showBottomSheet = false
    @State private var showOpeningHoursSheet = false
    @State private var measuredHeight: CGFloat = 0
    
    @State private var selected: ProfileTab = .posts
    @Namespace private var indicatorNS
    
    @ViewBuilder var header: () -> Header
    @ViewBuilder var actions: () -> Actions
    
    var onNavigateToUserProfile: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            header()
            
            ScrollView {
                VStack(spacing: 15) {
                    ProfileCountersView(
                        counters: user.counters,
                        onNavigateToUserSocial: onNavigateToUserSocial
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
                        ProfileBusinessOwnerView(
                            businessOwner: owner,
                            onNavigateToUserProfile: onNavigateToUserProfile
                        )
                    }

                    ProfileContactView()

                    if let description = user.bio {
                        ProfileDescriptionView(description: description)
                    }
                }
            }
        }
    }
}
            
            
                        
//                        ZStack(alignment: .bottom) {
//                            Rectangle()
//                                .fill(.divider)
//                                .frame(height: 1)
//                                .frame(maxWidth: .infinity)
//                                .padding(.top, 0)
//                            
//                            HStack(spacing: 20) {
//                                ForEach(ProfileTab.allCases) { tab in
//                                    Button { withAnimation(.spring(response: 0.3, dampingFraction: 0.9) ) {
//                                        selected = tab
//                                        }
//                                    } label: {
//                                        VStack(spacing: 6) {
//                                            Image(systemName: tab.systemImage)
//                                                .foregroundStyle(selected == tab ? .primary : .secondary)
//                                            
//                                            ZStack {
//                                                // indicator activ
//                                                if selected == tab {
//                                                    Capsule()
//                                                        .matchedGeometryEffect(id: "underline", in: indicatorNS)
//                                                        .frame(height: 3)
//                                                        .offset(y: 8)
//                                                } else {
//                                                    Color.clear.frame(height: 3)
//                                                }
//                                            }
//                                        }
//                                        .frame(maxWidth: .infinity)
//                                        .padding(.vertical, 8)
//                                    }
//                                    .buttonStyle(.plain)
//                                }
//                            }
//                        }
            
//            GeometryReader { geo in
//                ScrollView(.vertical, showsIndicators: false) {
//                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
//                        VStack(spacing: 15) {
//                            ProfileCountersView(
//                                counters: user.counters,
//                                onNavigateToUserSocial: {}
//                            )
//                            .padding(.vertical, .xl)
//                            
//                            ProfileUserInfoView(
//                                url: user.avatarURL,
//                                fullName: user.fullName,
//                                profession: user.profession,
//                                isBusinessOrEmployee: user.isBusinessOrEmployee,
//                                ratingsAverage: user.counters.ratingsAverage,
//                                openingHours: user.openingHours,
//                                onShowOpeningHoursSheet: { //showOpeningHoursSheet = true
//                                }
//                            )
//                            
//                            MyProfileActionsView(onNavigateToEditProfile: {})
//                            
//                            if let owner = user.businessOwner {
//                                ProfileBusinessOwnerView(
//                                    businessOwner: owner,
//                                    onNavigateToUserProfile: {}
//                                )
//                            }
//                            
//                            ProfileContactView()
//                            
//                            if let description = user.bio {
//                                ProfileDescriptionView(description: description)
//                            }
//                        }
//                        
//                        Section {
//                            TabView(selection: $selected) {
//                                ProfilePostsTabView()
//                                    .tag(ProfileTab.posts)
//                                ProfileProductsTabView()
//                                    .tag(ProfileTab.products)
//                            }
//                            .tabViewStyle(.page(indexDisplayMode: .never))
//                        } header: {
//                            ProfileTabView()
//                        }
//                    }
//                }
//            }
        
        
        
//        header()
//        
//        ScrollView(.vertical) {
//            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
//                
//                VStack(spacing: 15) {
//                    ProfileCountersView(
//                        counters: user.counters,
//                        onNavigateToUserSocial: {}
//                    )
//                    .padding(.vertical, .xl)
//                    
//                    ProfileUserInfoView(
//                        url: user.avatarURL,
//                        fullName: user.fullName,
//                        profession: user.profession,
//                        isBusinessOrEmployee: user.isBusinessOrEmployee,
//                        ratingsAverage: user.counters.ratingsAverage,
//                        openingHours: user.openingHours,
//                        onShowOpeningHoursSheet: { showOpeningHoursSheet = true }
//                    )
//                    
//                    actions()
//                    
//                    if let owner = user.businessOwner {
//                        ProfileBusinessOwnerView(
//                            businessOwner: owner,
//                            onNavigateToUserProfile: onNavigateToUserProfile
//                        )
//                    }
//                    
//                    ProfileContactView()
//                    
//                    if let description = user.bio {
//                        ProfileDescriptionView(description: description)
//                    }
//                    
//                    Section {
//                        VStack {
//                            Text("fwefef")
//                            Text("fewfwefwef")
//                            Text("")
//                            Text("fewff")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("fewfef")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("wefwe")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("dwqdw")
//                            Text("")
//                            Text("dqwdqwdwq")
//                            Text("")
//                            Text("wqdwq")
//                            Text("")
//                            Text("dwdqwd")
//                            Text("wqdwdqw")
//                            Text("wqdwdqwd")
//                            Text("wdqdw")
//                            Text("fwefef")
//                            Text("fewfwefwef")
//                            Text("")
//                            Text("fewff")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("fewfef")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("wefwe")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("")
//                            Text("dwqdw")
//                            Text("")
//                            Text("dqwdqwdwq")
//                            Text("")
//                            Text("wqdwq")
//                            Text("")
//                            Text("dwdqwd")
//                            Text("wqdwdqw")
//                            Text("wqdwdqwd")
//                            Text("wdqdw")
//                        }
//                    } header: {
//                        ProfileTabView()
//                    }
//                }
//                .sheet(isPresented: $showOpeningHoursSheet) {
//                    VStack {
//                        Text("Opening Hours Sheet")
//                    }
//                    .padding(.top, .s)
//                    .padding(.bottom)
//                    .background(
//                        GeometryReader { geo in
//                            Color.clear
//                                .onAppear { measuredHeight = geo.size.height }
//                                .onChange(of: geo.size.height) { _, new in
//                                    measuredHeight = new
//                                }
//                        }
//                    )
//                    .presentationDetents([.height(max(100, measuredHeight + 16))])
//                    .presentationContentInteraction(.resizes)
//                    .presentationDragIndicator(.hidden)
//                    .presentationCornerRadius(25)
//                }
//                .sheet(isPresented: $showBottomSheet) {
//                    VStack {
//                        ListItemView(
//                            title: "Creaza o postare",
//                            leadingIcon: "camera",
//                            onClick: {},
//                            showTrailingIcon: false
//                        )
//                        .padding(.horizontal)
//                        
//                        ListItemView(
//                            title: "Afacerea mea",
//                            leadingIcon: "bag",
//                            onClick: {
//                                showBottomSheet = false
//                                
//                            },
//                            showTrailingIcon: false
//                        )
//                        .padding(.horizontal)
//                        
//                        ListItemView(
//                            title: "Setari",
//                            leadingIcon: "gearshape",
//                            onClick: {
//                                showBottomSheet = false
//                                
//                            },
//                            showTrailingIcon: false
//                        )
//                        .padding(.horizontal)
//                    }
//                    .padding(.top, .s)
//                    .padding(.bottom)
//                    .background(
//                        GeometryReader { geo in
//                            Color.clear
//                                .onAppear { measuredHeight = geo.size.height }
//                                .onChange(of: geo.size.height) { _, new in
//                                    measuredHeight = new
//                                }
//                        }
//                    )
//                    .presentationDetents([.height(max(100, measuredHeight + 16))])
//                    .presentationContentInteraction(.resizes)
//                    .presentationDragIndicator(.hidden)
//                    .presentationCornerRadius(25)
//                }
//            }
//        }

//#Preview("Light - My Profile") {
//    ProfileLayout(
//        user: dummyUserProfile,
//        header: {
//            MyProfileHeaderView(username: "radu_balgiu")
//        },
//        actions: {
//            MyProfileActionsView(onNavigateToEditProfile: {})
//        },
//        onNavigateToUserProfile: {}
//    )
//}
//
//#Preview("Dark - My Profile") {
//    ProfileLayout(
//        user: dummyUserProfile,
//        header: {
//            MyProfileHeaderView(username: "radu_balgiu")
//        },
//        actions: {
//            MyProfileActionsView(onNavigateToEditProfile: {})
//        },
//        onNavigateToUserProfile: {}
//    )
//    .preferredColorScheme(.dark)
//}
//
//#Preview("Light - UserProfile") {
//    ProfileLayout(
//        user: dummyUserProfile,
//        header: {
//            UserProfileHeader(username: "radu_balgiu")
//        },
//        actions: {
//            UserProfileActions()
//        },
//        onNavigateToUserProfile: {}
//    )
//}
//
//#Preview("Dark - UserProfile") {
//    ProfileLayout(
//        user: dummyUserProfile,
//        header: {
//            UserProfileHeader(username: "radu_balgiu")
//        },
//        actions: {
//            UserProfileActions()
//        },
//        onNavigateToUserProfile: {}
//    )
//    .preferredColorScheme(.dark)
//}
