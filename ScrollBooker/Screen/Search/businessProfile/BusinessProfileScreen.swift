//
//  BusinessProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

private struct SectionOffsetKey: PreferenceKey {
    static var defaultValue: [BusinessProfileSection: CGFloat] = [:]
    static func reduce(value: inout [BusinessProfileSection: CGFloat], nextValue: () -> [BusinessProfileSection: CGFloat]) {
        value.merge(nextValue()) { _, new in new }
    }
}

struct BusinessProfileScreen: View {
    let viewModel: BusinessProfileViewModel
    let onBack: () -> Void
    let onNavigateToBusinessProfile: (String) -> Void

    private let imageHeight: CGFloat = 250
    private let headerHeight: CGFloat = 56
    private let tabRowHeight: CGFloat = 48

    @State private var activeSection: BusinessProfileSection? = nil
    @State private var isStickyActive = false
    @State private var scrollOffset: CGFloat = 0
    @State private var isProgrammaticScroll = false

    var body: some View {
        GeometryReader { rootGeo in
            let safeTop = rootGeo.safeAreaInsets.top
            let topNavigationBarHeight = headerHeight + safeTop
            let stickyBarHeight = topNavigationBarHeight + tabRowHeight

            ZStack(alignment: .top) {
                contentView(
                    topNavigationBarHeight: topNavigationBarHeight,
                    stickyBarHeight: stickyBarHeight
                )

                headerOverlay(safeTop: safeTop)
            }
            .ignoresSafeArea(edges: .top)
        }
    }

    // MARK: - Content (loading / error / success)

    @ViewBuilder
    private func contentView(topNavigationBarHeight: CGFloat, stickyBarHeight: CGFloat) -> some View {
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
            successScrollView(
                profile: profile,
                topNavigationBarHeight: topNavigationBarHeight,
                stickyBarHeight: stickyBarHeight
            )
        }
    }

    private func successScrollView(
        profile: BusinessProfile,
        topNavigationBarHeight: CGFloat,
        stickyBarHeight: CGFloat
    ) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                scrollBody(
                    profile: profile,
                    topNavigationBarHeight: topNavigationBarHeight,
                    proxy: proxy
                )
            }
            .coordinateSpace(name: "scrollArea")
            .safeAreaInset(edge: .top, spacing: 0) {
                Color.clear.frame(height: topNavigationBarHeight)
            }
            .onScrollGeometryChange(for: CGFloat.self) { geo in
                geo.contentOffset.y
            } action: { _, newOffset in
                handleScrollChange(newOffset: newOffset, topNavigationBarHeight: topNavigationBarHeight)
            }
            .onPreferenceChange(SectionOffsetKey.self) { offsets in
                handlePreferenceChange(offsets: offsets, stickyBarHeight: stickyBarHeight)
            }
        }
    }

    private func scrollBody(
        profile: BusinessProfile,
        topNavigationBarHeight: CGFloat,
        proxy: ScrollViewProxy
    ) -> some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            topContent(profile: profile, topNavigationBarHeight: topNavigationBarHeight)

            Section {
                sectionsContent(profile: profile)
            } header: {
                pinnedTabRow(proxy: proxy)
            }
        }
    }

    private func topContent(
        profile: BusinessProfile,
        topNavigationBarHeight: CGFloat
    ) -> some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: profile.mediaFiles.first?.thumbnailUrl ?? "")) { img in
                img.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(height: imageHeight)
            .frame(maxWidth: .infinity)
            .clipped()
            .padding(.top, -topNavigationBarHeight)
            .scaleEffect(scrollOffset < 0 ? 1.0 - (scrollOffset / imageHeight) : 1.0, anchor: .top)
            .offset(y: scrollOffset < 0 ? scrollOffset : 0)

            BusinessInfoView(profile: profile)
        }
    }

    private func pinnedTabRow(proxy: ScrollViewProxy) -> some View {
        BusinessProfileTabRow(
            selected: Binding(
                get: { activeSection ?? .services },
                set: { activeSection = $0 }
            ),
            onSelect: { clickedTab in
                scrollToSection(clickedTab, proxy: proxy)
            }
        )
        .frame(height: tabRowHeight)
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .bottom)
    }

    @ViewBuilder
    private func sectionsContent(profile: BusinessProfile) -> some View {
        sectionBlock(.services) { BusinessServicesTabView(products: profile.userProducts) }
        sectionBlock(.posts) { GenericTabTestView(tabName: "Posts") }
        sectionBlock(.employees) { GenericTabTestView(tabName: "Echipă") }
        sectionBlock(.reviews) { GenericTabTestView(tabName: "Recenzii") }
        sectionBlock(.about) { GenericTabTestView(tabName: "Despre") }
    }

    // MARK: - Header overlay (always floating)

    private func headerOverlay(safeTop: CGFloat) -> some View {
        BusinessProfileHeader(
            showTitle: isStickyActive,
            title: viewModel.uiState.data?.owner.fullName ?? "",
            onBack: onBack
        )
        .frame(height: headerHeight)
        .padding(.top, safeTop)
        .background(
            Color(.systemBackground)
                .opacity(isStickyActive ? 1.0 : 0.0)
                .ignoresSafeArea(edges: .top)
        )
        .animation(isStickyActive ? .easeInOut(duration: 0.2) : .none, value: isStickyActive)
        .zIndex(10)
    }

    // MARK: - Scroll handlers

    private func handleScrollChange(newOffset: CGFloat, topNavigationBarHeight: CGFloat) {
        let adjustedOffset = newOffset + topNavigationBarHeight
        scrollOffset = adjustedOffset
        let threshold = imageHeight - topNavigationBarHeight
        isStickyActive = adjustedOffset >= threshold
    }

    private func handlePreferenceChange(offsets: [BusinessProfileSection: CGFloat], stickyBarHeight: CGFloat) {
        guard !isProgrammaticScroll else { return }
        let threshold = stickyBarHeight + 1
        let visible = offsets.filter { $0.value <= threshold }
        if let match = visible.max(by: { $0.value < $1.value }), activeSection != match.key {
            activeSection = match.key
        }
    }

    private func scrollToSection(_ section: BusinessProfileSection, proxy: ScrollViewProxy) {
        isProgrammaticScroll = true
        activeSection = section
        withAnimation(.easeInOut(duration: 0.25)) {
            proxy.scrollTo(section, anchor: .top)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            isProgrammaticScroll = false
        }
    }

    @ViewBuilder
    private func sectionBlock<Content: View>(
        _ section: BusinessProfileSection,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(.title2.weight(.heavy))
                .padding(.horizontal, 16)
                .padding(.top, 16)
            content()
        }
        .id(section)
        .background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: SectionOffsetKey.self,
                    value: [section: geo.frame(in: .named("scrollArea")).minY]
                )
            }
        )
    }
}


struct GenericTabTestView: View {
    let tabName: String

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<15, id: \.self) { index in
                HStack {
                    Text("Element \(index + 1) din secțiunea \(tabName)")
                        .font(.body)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)

                Divider()
                    .padding(.horizontal, 16)
            }
        }
        .background(Color(.systemBackground))
    }
}
