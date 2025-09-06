//
//  InboxScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct InboxScreen: View {
    @EnvironmentObject private var session: SessionManager
    @StateObject private var viewModel: InboxViewModel
    
    init(viewModel: InboxViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Header(
                    title: String(localized: "inbox"),
                    enableBack: false
                )
                
                List {
                    ForEach(viewModel.notifications) { notification in
                        NotificationItemView(
                            notification: notification,
                            onNavigateToEmployment: {}
                        )
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                Task { await viewModel.delete(notification) }
                            } label: {
                                Label("delete", systemImage: "trash")
                            }
                            .tint(Color.errorSB)
                        }
                        .onAppear {
                            Task { await viewModel.loadMoreIfNeeded(currentNotification: notification) }}
                    }
                    
                    if viewModel.isLoading && !viewModel.isRefreshing {
                        ProgressView()
                            .padding(.vertical, 16)
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.refresh()
                }
                .task { await viewModel.initialLoadIfNeeded() }
            }
            
            if viewModel.isInitialLoading {
                ProgressView()
                    .scaleEffect(1.2)
            }
        }
    }
}


// SCROLL CU TAB BAR STICKY
//            ScrollView(.vertical, showsIndicators: false) {
//                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
//                    VStack(spacing: 15) {
//                        ProfileCountersView(
//                            counters: user.counters,
//                            onNavigateToUserSocial: {}
//                        )
//                        .padding(.vertical, .xl)
//
//                        ProfileUserInfoView(
//                            url: user.avatarURL,
//                            fullName: user.fullName,
//                            profession: user.profession,
//                            isBusinessOrEmployee: user.isBusinessOrEmployee,
//                            ratingsAverage: user.counters.ratingsAverage,
//                            openingHours: user.openingHours,
//                            onShowOpeningHoursSheet: { //showOpeningHoursSheet = true
//                            }
//                        )
//
//                        MyProfileActionsView(onNavigateToEditProfile: {})
//
//                        if let owner = user.businessOwner {
//                            ProfileBusinessOwnerView(
//                                businessOwner: owner,
//                                onNavigateToUserProfile: {}
//                            )
//                        }
//
//                        ProfileContactView()
//
//                        if let description = user.bio {
//                            ProfileDescriptionView(description: description)
//                        }
//                    }
//
//                    Section {
//                        TabView(selection: $selectedTab) {
//                            ProfilePostsTabView()
//                                .tag(ProfileTab.posts)
//                            ProfileProductsTabView()
//                                .tag(ProfileTab.products)
//                            ProfileRepostsTabView()
//                                .tag(ProfileTab.reposts)
//                            ProfileBookmarksTabView()
//                                .tag(ProfileTab.bookmarks)
//                            ProfileInfoTabView()
//                                .tag(ProfileTab.info)
//                        }
//                        .tabViewStyle(.page(indexDisplayMode: .never))
//                        .containerRelativeFrame(.vertical)
//                    } header: {
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
//                                        selectedTab = tab
//                                        }
//                                    } label: {
//                                        VStack(spacing: 6) {
//                                            Image(systemName: tab.systemImage)
//                                                .foregroundStyle(selectedTab == tab ? .primary : .secondary)
//
//                                            ZStack {
//                                                // indicator activ
//                                                if selectedTab == tab {
//                                                    Capsule()
//                                                        .matchedGeometryEffect(id: "underline", in: ns)
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
//                        .background(.backgroundSB)
//                    }
//                }
//            }
//            .ignoresSafeArea(.container, edges: .bottom)

//struct TabBar: View {
//@Binding var selected: ProfileTab
//@Namespace private var ns
//
//var body: some View {
//    HStack(spacing: 0) {
//        ForEach(ProfileTab.allCases, id: \.self) { tab in
//            Button {
//                withAnimation(.easeInOut) {
//                    selected = tab
//                }
//            } label: {
//                VStack(spacing: 6) {
////                    Text(tab.rawValue)
////                        .font(.headline)
//                    Image(systemName: tab.systemImage)
//                    ZStack {
//                        Rectangle()
//                            .frame(height: 2)
//                            .opacity(0)
//                        if selected == tab {
//                            Rectangle()
//                                .frame(height: 2)
//                                .matchedGeometryEffect(id: "underline", in: ns)
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.plain)
//        }
//    }
//    .padding(.vertical, 10)
//    .padding(.horizontal)
//    }
//}
//
//struct TabContent: View {
//    let selectedTab: ProfileTab
//
//    var body: some View {
//        switch selectedTab {
//        case .posts:
//            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 2) {
//                ForEach(0..<50, id: \.self) { index in
//                    Rectangle()
//                        .fill(Color.blue.opacity(0.5))
//                        .aspectRatio(1, contentMode: .fit)
//                        .overlay(Text("\(index)").foregroundColor(.white))
//                }
//            }
//
//        case .products:
//            LazyVStack(spacing: 12) {
//                ForEach(0..<20, id: \.self) { index in
//                    Text("Review \(index)")
//                        .frame(maxWidth: .infinity, minHeight: 60)
//                        .background(Color.green.opacity(0.2))
//                        .cornerRadius(8)
//                        .padding(.horizontal)
//                }
//            }
//            .padding(.top, 10)
//        case .reposts:
//            LazyVStack(spacing: 12) {
//                ForEach(0..<20, id: \.self) { index in
//                    Text("Review \(index)")
//                        .frame(maxWidth: .infinity, minHeight: 60)
//                        .background(Color.green.opacity(0.2))
//                        .cornerRadius(8)
//                        .padding(.horizontal)
//                }
//            }
//            .padding(.top, 10)
//        case .bookmarks:
//            LazyVStack(spacing: 12) {
//                ForEach(0..<20, id: \.self) { index in
//                    Text("Review \(index)")
//                        .frame(maxWidth: .infinity, minHeight: 60)
//                        .background(Color.green.opacity(0.2))
//                        .cornerRadius(8)
//                        .padding(.horizontal)
//                }
//            }
//            .padding(.top, 10)
//        case .info:
//            LazyVStack(spacing: 12) {
//                ForEach(0..<20, id: \.self) { index in
//                    Text("Review \(index)")
//                        .frame(maxWidth: .infinity, minHeight: 60)
//                        .background(Color.green.opacity(0.2))
//                        .cornerRadius(8)
//                        .padding(.horizontal)
//                }
//            }
//            .padding(.top, 10)
//        }
//    }
//}

//#Preview("Light") {
//    InboxScreen(
//        //onNavigateToEmployment: {}
//    )
//}
//
//#Preview("Dark") {
//    InboxScreen(
//        //onNavigateToEmployment: {}
//    )
//        .preferredColorScheme(.dark)
//}
