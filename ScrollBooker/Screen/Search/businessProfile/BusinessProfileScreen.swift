//
//  BusinessProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

private struct SectionTopKey: PreferenceKey {
    static var defaultValue: [BusinessProfileSection: CGFloat] = [:]
    static func reduce(value: inout [BusinessProfileSection: CGFloat], nextValue: () -> [BusinessProfileSection: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct BusinessProfileScreen: View {
    let viewModel: BusinessProfileViewModel
    let onBack: () -> Void
    let onNavigateToBusinessProfile: (String) -> Void
    
    private let imageHeight: CGFloat = 250
    private let headerHeight: CGFloat = 56
    private let tabRowHeight: CGFloat = 48

    @State private var selected: BusinessProfileSection = .services
    @State private var tops: [BusinessProfileSection: CGFloat] = [:]
    @State private var currentScrollOffset: CGFloat = 0
    @State private var isExplicitScrolling = false
    @State private var isStickyActive = false

    var body: some View {
        GeometryReader { rootGeo in
            let safeTop = rootGeo.safeAreaInsets.top
            let topNavigationBarHeight = headerHeight + safeTop

            ZStack(alignment: .top) {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()
                        .onAppear {
                            Task { await viewModel.loadBusinessProfile() }
                        }

                case .error(let message):
                    ErrorView(message: message) {
                        Task { await viewModel.refresh() }
                    }

                case .success(let profile):
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                                GeometryReader { geo in
                                    let minY = geo.frame(in: .named("SCROLL")).minY
                                    AsyncImage(url: URL(string: profile.mediaFiles.first?.thumbnailUrl ?? "")) { img in
                                        img.resizable().aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color.gray.opacity(0.2)
                                    }
                                    .frame(width: geo.size.width, height: imageHeight + (minY > 0 ? minY : 0))
                                    .clipped()
                                    .offset(y: minY > 0 ? -minY : 0)
                                    .preference(key: ScrollOffsetKey.self, value: minY)
                                }
                                .frame(height: imageHeight)

                                // 2. Informații despre Business (Titlu, adrese, etc)
                                BusinessInfoView(profile: profile)

                                // 3. Secțiunile de conținut cu Header-ul Sticky
                                Section {
                                    section(.services) {
                                        BusinessServicesTabView(products: profile.userProducts)
                                    }
                                    section(.posts) {
                                        BusinessPostsTabView(posts: profile.posts)
                                    }
                                    section(.employees) {
                                        BusinessEmployeesTabView(employees: profile.employees)
                                    }
                                    section(.reviews) {
                                        BusinessReviewsTabView()
                                    }
                                    section(.about) {
                                        BusinessAboutTabView(
                                            description: profile.description,
                                            schedules: profile.schedules,
                                            location: profile.location,
                                            fullName: profile.owner.fullName,
                                            nearbyBusinesses: profile.nearbyBusinesses,
                                            onNavigateToBusinessProfile: onNavigateToBusinessProfile
                                        )
                                    }
                                } header: {
                                    BusinessProfileTabRow(
                                        selected: $selected,
                                        onSelect: { section in
                                            isExplicitScrolling = true
                                            selected = section
                                            withAnimation(.easeInOut(duration: 0.25)) {
                                                proxy.scrollTo(section.id, anchor: .top)
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                isExplicitScrolling = false
                                            }
                                        }
                                    )
                                    .frame(height: tabRowHeight)
                                    .background(Color(.systemBackground))
                                    .overlay(Divider(), alignment: .bottom)
                                }
                            }
                        }
                        .coordinateSpace(name: "SCROLL")
                        .onPreferenceChange(ScrollOffsetKey.self) { value in
                            currentScrollOffset = value
                            let calculatedSticky = -value >= (imageHeight - topNavigationBarHeight)
                            if isStickyActive != calculatedSticky {
                                isStickyActive = calculatedSticky
                            }
                        }
                        .onPreferenceChange(SectionTopKey.self) { newTops in
                            guard !isExplicitScrolling else { return }
                            tops = newTops

                            let threshold = topNavigationBarHeight + tabRowHeight
                            let activeSection = BusinessProfileSection.allCases.last { section in
                                if let minY = newTops[section] {
                                    return minY <= threshold + 8
                                }
                                return false
                            }
                            if let target = activeSection, target != selected {
                                selected = target
                            }
                        }
                    }
                }

                VStack(spacing: 0) {
                    BusinessProfileHeader(
                        showTitle: isStickyActive,
                        title: viewModel.uiState.data?.owner.fullName ?? "",
                        onBack: onBack
                    )
                    .frame(height: headerHeight)
                    .padding(.top, safeTop)
                    .background(Color(.systemBackground).opacity(isStickyActive ? 1.0 : 0.0))
                    
                    if isStickyActive {
                        Color.clear
                            .frame(height: tabRowHeight)
                            .background(Color(.systemBackground))
                    }
                }
                .ignoresSafeArea(edges: .top)
                .zIndex(10)
            }
            .ignoresSafeArea(edges: .top)
        }
    }

    private func section<Content: View>(_ s: BusinessProfileSection, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .id(s.id)
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(
                        key: SectionTopKey.self,
                        value: [s: geo.frame(in: .named("SCROLL")).minY]
                    )
            }
        )
    }
}
            
