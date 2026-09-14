//
//  NetworkStatusBanner.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import SwiftUI

struct NetworkStatusBanner: View {
    var body: some View {
        HStack(spacing: AppSize.s.rawValue) {
            Image(systemName: "wifi.slash")
            Text(String(localized: "noInternetConnection"))
                .font(.subheadline.weight(.semibold))
        }
        .padding(.vertical, AppSize.s.rawValue)
        .frame(maxWidth: .infinity)
        .background(Color.errorSB)
        .foregroundColor(.onErrorSB)
    }
}
