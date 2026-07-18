//
//  Size.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

enum AppSize: CGFloat {
    case xxs = 2
    case xs = 4
    case s = 8
    case m = 12
    case base = 16
    case xl = 24
    case xxl = 32
}

extension View {
    func padding(_ spacing: AppSize) -> some View {
        self.padding(spacing.rawValue)
    }
    
    func padding(_ edges: Edge.Set, _ spacing: AppSize) -> some View {
        self.padding(edges, spacing.rawValue)
    }
}
