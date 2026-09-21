//
//  ServiceStepHeader.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

struct ServiceStepHeader: View {
    var onBack: () -> Void
    var serviceDomainName: String?
    var serviceDomainUrl: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onBack) {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(10)
                    .clipShape(Circle())
            }
            .padding(.horizontal, .base)
            .padding(.top, .base)
            .padding(.bottom, .s)

            VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.surfaceSB)

                    if let urlString = serviceDomainUrl, let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            if case .success(let image) = phase {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .clipped()

                Text(serviceDomainName ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB)
            }
            .padding(.horizontal, .base)
        }
    }
}
