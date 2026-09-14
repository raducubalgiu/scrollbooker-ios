//
//  StatTitleView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct StatTitleView: View {
    let title: String
    var onClick: () -> Void = {}

    var body: some View {
        HStack(spacing: AppSize.s.rawValue) {
            Text(title)
                .font(.headline.bold())
                .foregroundColor(.onBackgroundSB)

            Button(action: onClick) {
                Image(systemName: "info.circle")
                    .foregroundColor(.gray)
            }
        }
    }
}
