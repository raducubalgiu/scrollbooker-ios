//
//  InputSelectPlaceholder.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

struct InputSelectPlaceholder: View {
    let options: [Option]
    let selectedOption: String
    let placeholder: String
    let label: String
    var isLoading: Bool = false
    var backgroundColor: Color = .surfaceSB
    var onValueChange: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.xs.rawValue) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)

            if isLoading {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Spacer()
                }
                .padding(.base)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(backgroundColor)
                )
            } else {
                Menu {
                    ForEach(options) { option in
                        Button(action: { onValueChange(option.value) }) {
                            Text(option.name)
                        }
                    }
                } label: {
                    HStack {
                        let selectedName = options.first(where: { $0.value == selectedOption })?.name
                        Text(selectedName ?? placeholder)
                            .font(.body)
                            .foregroundColor(selectedName != nil ? .onBackgroundSB : .gray)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }
                    .padding(.base)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(backgroundColor)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
