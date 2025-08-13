//
//  Size.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

enum Size {
    enum Spacing: CGFloat {
        case base = 16
        case xs = 4
        case s = 8
        case m = 12
        case xl = 24
        case xxl = 32
    }
}

extension View {
    func padding(_ spacing: Size.Spacing) -> some View {
        padding(spacing.rawValue)
    }
    
    func padding(_ edges: Edge.Set, _ spacing: Size.Spacing) -> some View {
        padding(edges, spacing.rawValue)
    }
}
