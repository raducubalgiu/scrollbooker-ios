//
//  BusinessProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

// MARK: - Preference Keys (tracking scroll + secțiuni vizibile)

private struct ScrollYKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct SectionTopKey: PreferenceKey {
    static var defaultValue: [BusinessProfileSection: CGFloat] = [:]
    static func reduce(value: inout [BusinessProfileSection: CGFloat],
                       nextValue: () -> [BusinessProfileSection: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

// MARK: - Screen

struct BusinessProfileScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Namespace private var indicatorNS

    // UI constants (le poți muta în Theme)
    private let imageHeight: CGFloat = 250
    private let headerHeight: CGFloat = 56
    private let tabRowHeight: CGFloat = 48

    @State private var selected: BusinessProfileSection = .services
    @State private var scrollY: CGFloat = 0 // offset pozitiv când urci
    @State private var tops: [BusinessProfileSection: CGFloat] = [:]

    var body: some View {
        ZStack(alignment: .top) {
            // Header image cu parallax + fade
            headerImage

            // Conținut scrollabil cu tab row sticky
            ScrollViewReader { proxy in
                ScrollView {
                    // Măsurăm scroll-ul global
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollYKey.self,
                                        value: -geo.frame(in: .named("SCROLL")).minY)
                    }
                    .frame(height: 0)

                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        // Spațiu egal cu înălțimea imaginii (imaginea stă în ZStack, nu în scroll)
                        Color.clear
                            .frame(height: imageHeight)

                        // Info business (titlu mare, rating, etc) – opțional
                        BusinessInfoView()

                        // TabRow sticky
                        Section {
                            // Secțiunile – fiecare are un .id pentru scrollTo și un GeometryReader pt top
                            section(.services) {
                                BusinessServicesTabView()
                            }
                            section(.social) {
                                BusinessSocialTabView()
                            }
                            section(.team) {
                                BusinessTeamTabView()
                            }
                            section(.reviews) {
                                BusinessReviewsTabView()
                            }
                            section(.about) {
                                BusinessAboutTabView()
                            }
                            Color.clear.frame(height: 16) // padding bottom
                        } header: {
                            BusinessProfileTabRow(
                                selected: $selected,
                                onSelect: { section in
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        proxy.scrollTo(section.id, anchor: .top)
                                        selected = section
                                    }
                                }
                            )
                        }
                    }
                }
                .coordinateSpace(name: "SCROLL")
                .onPreferenceChange(ScrollYKey.self) { scrollY = $0 }
                .onPreferenceChange(SectionTopKey.self) { new in
                    tops = new
                    // alegem secțiunea cea mai sus (>= 0) pentru select
                    if let best = new.sorted(by: { $0.value < $1.value })
                        .first(where: { $0.value >= 0 })?.key {
                        if best != selected { selected = best }
                    }
                }
            }

            // Top bar peste imagine – title apare doar când header-ul e colapsat
            topBar
        }
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Subviews

    private var collapseProgress: CGFloat {
        // 0 -> la top; 1 -> după ce imaginea dispare
        let denom = max(imageHeight - headerHeight, 1)
        return min(max(scrollY / denom, 0), 1)
    }

    private var headerImage: some View {
        let translate = -min(scrollY, imageHeight) // parallax în sus
        let alpha = 1 - collapseProgress // fade out

        return ZStack {
            AsyncImage(url: URL(string: "https://media.scrollbooker.ro/frizeria-figaro-location-1.avif")) { img in
                img
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
        }
        .frame(height: imageHeight)
        .frame(maxWidth: .infinity)
        .clipped()
        .opacity(alpha)
        .offset(y: translate) // parallax
    }

private var topBar: some View {
    HStack {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .font(.title3.weight(.semibold))
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
        }

        Spacer()

        // Right action placeholder
        Button { } label: {
            Image(systemName: "square.and.arrow.up")
                .font(.title3.weight(.semibold))
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
        }
    }
    .padding(.horizontal, 16)
    .padding(.top, safeTopInset())
    .frame(height: headerHeight + safeTopInset(), alignment: .bottom)
    .overlay(
        Text("House Of Barbers")
            .font(.system(size: 18, weight: .bold))
            .opacity(collapseProgress) // apare când imaginea e colapsată
    )
    .background(
        Color(.systemBackground)
            .opacity(collapseProgress) // devine bar solid când scrollezi
    )
}

// Helper pentru o secțiune cu tracking de „top” relativ la viewport
private func section<Content: View>(_ s: BusinessProfileSection,
    @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .id(s.id)
        .background( // măsurăm Y-ul top-ului secțiunii în coordonatele SCROLL
            GeometryReader { geo in
                Color.clear
                    .preference(key: SectionTopKey.self,
                                value: [s: geo.frame(in: .named("SCROLL")).minY - headerHeight - tabRowHeight])
            }
        )
    }

// MARK: - Utils
private func safeTopInset() -> CGFloat {
    UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow?.safeAreaInsets.top }
        .first ?? 0
    }
}

#Preview("Light") {
    BusinessProfileScreen()
}

#Preview("Dark") {
    BusinessProfileScreen()
        .preferredColorScheme(.dark)
}
