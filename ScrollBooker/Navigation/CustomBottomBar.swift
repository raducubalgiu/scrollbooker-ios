//
//  CustomBottomBar.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import SwiftUI

struct CustomTabBarItem: Identifiable, Hashable {
    let id = UUID()
    let tab: MainTab
    let title: String
    let systemImage: String
    var badge: Int = 0
}

struct CustomTabBar: View {
    @Binding var selected: MainTab
    let items: [CustomTabBarItem]
    var background: Color = Color.backgroundSB
    private let barHeight: CGFloat = 56

    var body: some View {
        ZStack {
            Spacer()
            
            HStack {
                ForEach(items) { item in
                    Button {
                        selected = item.tab
                    } label: {
                        VStack(spacing: 4) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: item.systemImage)
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundColor(foregroundColor(for: item.tab))
                                
                                if item.badge > 0 {
                                    Text("\(item.badge)")
                                        .font(.system(size: 12, weight: .bold))
                                        .padding(.horizontal, 7.5)
                                        .padding(.vertical, 2)
                                        .background(Capsule().fill(Color.errorSB))
                                        .foregroundStyle(.white)
                                        .offset(x: 15, y: -5)
                                }
                            }
                            Text(item.title)
                                .font(.system(size: 11.5))
                                .foregroundColor(foregroundColor(for: item.tab))
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(height: barHeight)
            .padding(.horizontal, 8)
        }
        .background(
            Rectangle()
                .fill(background)
                .ignoresSafeArea(edges: .bottom)
                .overlay(Divider(), alignment: .top)
        )
    }
    
    private func foregroundColor(for tab: MainTab) -> Color {
        if selected == .feed && tab == .feed {
            return Color.white
        } else {
            return (selected == tab) ? Color.onBackgroundSB : .gray
        }
    }
}
