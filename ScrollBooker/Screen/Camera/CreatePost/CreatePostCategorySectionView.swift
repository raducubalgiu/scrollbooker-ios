//
//  CreatePostCategorySectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.09.2026.
//

import SwiftUI

struct CreatePostCategorySectionView: View {
    var title: String = String(localized: "category")
    var sectionDescription: String = String(localized: "categorySectionDescription")
    let options: [SelectOption]
    let selectedOptionId: String
    var onSelect: (String) -> Void

    var body: some View {
        if !options.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.heavy)

                Text(sectionDescription)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, .xxs)

                FlowLayout(horizontalSpacing: AppSize.s.rawValue, verticalSpacing: AppSize.s.rawValue) {
                    ForEach(options, id: \.value) { option in
                        CategoryTagView(
                            label: option.name,
                            isSelected: selectedOptionId == option.value,
                            onClick: { onSelect(option.value) }
                        )
                    }
                }
                .padding(.top, .base)
            }
        }
    }
}
