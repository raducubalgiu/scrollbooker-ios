//
//  EmploymentRequestsScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

//import SwiftUI
//
//struct EmploymentsScreen: View {
//    var body: some View {
//        Header(title: String(localized: "employmentRequests"))
//        
//        Text("Employments Screen")
//        
//        Spacer()
//    }
//}
//
//#Preview("Light") {
//    EmploymentsScreen()
//}
//
//#Preview("Dark") {
//    EmploymentsScreen()
//        .preferredColorScheme(.dark)
//}

//import SwiftUI
//
//enum ProfileTab2: CaseIterable {
//case posts, reviews
//
//var title: String {
//    switch self {
//        case .posts: "Postări"
//        case .reviews: "Recenzii"
//        }
//    }
//}
//
//    struct EmploymentsScreen: View {
//        @State private var selectedTab: ProfileTab2 = .posts
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // HEADER FIX
//            ProfileHeaderView()
//                .frame(height: 150)
//                .background(Color.gray.opacity(0.2))
//
//            // SCROLL CU TAB BAR STICKY
//            ScrollView(.vertical, showsIndicators: false) {
//                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
//
//// SECTION: TabBar sticky + conținut
//                    Section {
//                        TabContent(selectedTab: selectedTab)
//                    } header: {
//                        TabBar(selected: $selectedTab)
//                            .background(Color.white)
//                            .zIndex(1)
//                    }
//                }
//            }
//        }
//    }
//    }
//
//struct ProfileHeaderView: View {
//    var body: some View {
//        VStack {
//            Text("Nume Utilizator")
//                .font(.largeTitle)
//                .padding(.top, 20)
//            Text("Bio scurtă aici")
//                .font(.subheadline)
//        }
//    }
//}
//
//struct TabBar: View {
//@Binding var selected: ProfileTab2
//@Namespace private var ns
//
//var body: some View {
//    HStack(spacing: 0) {
//        ForEach(ProfileTab2.allCases, id: \.self) { tab in
//            Button {
//                withAnimation(.easeInOut) {
//                    selected = tab
//                }
//            } label: {
//                VStack(spacing: 6) {
//                    Text(tab.title)
//                        .font(.headline)
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
//    let selectedTab: ProfileTab2
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
//}
//
//case .reviews:
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
