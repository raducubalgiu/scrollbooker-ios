//
//  SearchAdvancedFilters.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

struct SearchAdvancedFilters: View {
    var selectedSubFilterIds: [Int]?
    let filters: [Filter]
    var onSetSelectedFilter: (Int) -> Void

    var body: some View {
        if !filters.isEmpty {
            VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                Text(String(localized: "filters"))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)

                VStack(spacing: AppSize.base.rawValue) {
                    ForEach(filters) { filter in
                        let options = filter.subFilters.map {
                            Option(value: String($0.id), name: $0.name, description: $0.description)
                        }

                        let activeSubFilter = filter.subFilters.first { sub in
                            selectedSubFilterIds?.contains(sub.id) ?? false
                        }

                        InputSelectPlaceholder(
                            options: options,
                            selectedOption: activeSubFilter != nil ? String(activeSubFilter!.id) : "",
                            placeholder: filter.name,
                            label: filter.name,
                            isLoading: false,
                            backgroundColor: .backgroundSB,
                            onValueChange: { newValue in
                                if let subId = Int(newValue) {
                                    onSetSelectedFilter(subId)
                                }
                            }
                        )
                    }
                }
            }
            .padding(AppSize.base.rawValue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.surfaceSB)
            )
            .animation(.default, value: filters.count)
        }
    }
}
