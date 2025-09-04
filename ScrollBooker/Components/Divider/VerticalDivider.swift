//
//  VerticalDivider.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.08.2025.
//

import SwiftUI

struct VerticalDivider: View {
    var color: Color = .divider
    var width: CGFloat = 1
    var height: CGFloat? = nil
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: height)
    }
}

#Preview {
    VerticalDivider()
}
