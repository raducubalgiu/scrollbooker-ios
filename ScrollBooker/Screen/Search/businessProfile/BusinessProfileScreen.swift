//
//  BusinessProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

// MARK: - Preference Keys (tracking scroll + secțiuni vizibile)

private struct SectionTopKey: PreferenceKey {
    static var defaultValue: [BusinessProfileSection: CGFloat] = [:]
    static func reduce(value: inout [BusinessProfileSection: CGFloat],
                       nextValue: () -> [BusinessProfileSection: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

private struct CoverBottomKey: PreferenceKey {
    static var defaultValue: CGFloat = .greatestFiniteMagnitude
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

struct BusinessProfileScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Namespace private var indicatorNS

    // UI constants (le poți muta în Theme)
    private let imageHeight: CGFloat = 250
    private let headerHeight: CGFloat = 56
    private let tabRowHeight: CGFloat = 48

    @State private var selected: BusinessProfileSection = .services
    @State private var scrollY: CGFloat = 0
    @State private var tops: [BusinessProfileSection: CGFloat] = [:]
    
    @State private var coverBottomY: CGFloat = .greatestFiniteMagnitude

    var body: some View {
        ZStack(alignment: .top) {
            TopBar(showTitle: coverBottomY <= headerHeight)
                .background(Color.backgroundSB
                    .opacity(coverBottomY <= headerHeight + safeTopInset() ? 1 : 0)
                )
                
                .zIndex(10)
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        AsyncImage(
                            url: URL(string: "https://media.scrollbooker.ro/frizeria-figaro-location-1.avif")
                        ) { img in
                            img
                                .resizable()
                                .scaledToFit()
                                .frame(height: imageHeight)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .preference(
                                                key: CoverBottomKey.self,
                                                value: geo.frame(in: .named("SCROLL")).maxY
                                            )
                                    }
                                )
                                
                        } placeholder: {
                            Color.gray.opacity(0.2)
                                .frame(height: imageHeight)
                        }

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
                            .frame(height: tabRowHeight)
                            .background(Color.backgroundSB)
                            .overlay(Divider(), alignment: .bottom)
                            .zIndex(1)
                        }
                    }
                }
                .coordinateSpace(name: "SCROLL")
                .onPreferenceChange(CoverBottomKey.self) { coverBottomY = $0 }
                .onPreferenceChange(SectionTopKey.self) { new in
                    tops = new
                    if let best = new.sorted(by: { $0.value < $1.value })
                        .first(where: { $0.value >= 0 })?.key {
                        if best != selected { selected = best }
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }
    
private struct TopBar: View {
    var showTitle: Bool
    
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "chevron.backward")
                    .font(.title3.weight(.semibold))
                    .padding(8)
                    .background(.ultraThinMaterial)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
                    .font(.title3.weight(.semibold))
                    .padding(8)
                    .background(.ultraThinMaterial)
            }
        }
    }
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
}

private func safeTopInset() -> CGFloat {
    UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow?.safeAreaInsets.top }
        .first ?? 0
}

#Preview("Light") {
    BusinessProfileScreen()
}

#Preview("Dark") {
    BusinessProfileScreen()
        .preferredColorScheme(.dark)
}
