//
//  SearchFiltersSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import SwiftUI

struct SearchFiltersSheet: View {
    var viewModel: SearchViewModel
    var onClose: () -> Void
    var onFilter: (SearchFiltersSheetState) -> Void
    
    @State private var sheetState: SearchFiltersSheetState
    private let defaultMaxPrice: Decimal = 1500
    
    init(
        viewModel: SearchViewModel,
        onClose: @escaping () -> Void,
        onFilter: @escaping (SearchFiltersSheetState) -> Void
    ) {
        self.viewModel = viewModel
        self.onClose = onClose
        self.onFilter = onFilter
        
        let initialSort = SearchSortEnum(rawValue: viewModel.currentSort ?? "recommended") ?? .recommended
        _sheetState = State(initialValue: SearchFiltersSheetState(
            maxPrice: viewModel.maxPrice ?? defaultMaxPrice,
            sort: initialSort,
            hasDiscount: viewModel.hasDiscount
        ))
    }
    
    private var isConfirmEnabled: Bool {
        sheetState.hasChangesComparedTo(
            maxPrice: viewModel.maxPrice,
            sort: viewModel.currentSort,
            hasDiscount: viewModel.hasDiscount
        )
    }
    
    private var isClearEnabled: Bool {
        sheetState.hasDiscount ||
        sheetState.maxPrice != defaultMaxPrice ||
        sheetState.sort != .recommended
    }
    
    private var sliderValueBinding: Binding<Double> {
        Binding(
            get: {
                if let decimal = sheetState.maxPrice {
                    return (decimal as NSDecimalNumber).doubleValue
                }
                return 1500.0
            },
            set: { sheetState.maxPrice = Decimal($0) }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(10)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            Text(String(localized: "filters"))
                .font(.largeTitle)
                .bold()
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        SearchSheetInfoRow(
                            leftText: String(localized: "options"),
                            rightText: ""
                        )
                        
                        Button(action: {
                            sheetState.hasDiscount.toggle()
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "percent")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Oferte")
                                    .font(.body)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.primary)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 14)
                            .background(sheetState.hasDiscount ? Color.secondary.opacity(0.05) : Color.clear)
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(
                                        sheetState.hasDiscount ? Color.primarySB : Color.dividerSB,
                                        lineWidth: sheetState.hasDiscount ? 2 : 1
                                    )
                            )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        let priceDisplay = sheetState.maxPrice != nil ? "\(Int((sheetState.maxPrice! as NSDecimalNumber).doubleValue)) RON" : "1500 RON"
                        SearchSheetInfoRow(leftText: "Preț maxim", rightText: priceDisplay)
                        
                        Slider(value: sliderValueBinding, in: 0...1500, step: 10)
                            .accentColor(.accentColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 14) {
                        SearchSheetInfoRow(leftText: "Sortează după", rightText: "")
                        
                        ForEach(SearchSortEnum.allCases) { option in
                            InputRadio(
                                title: option.label,
                                isSelected: sheetState.sort == option,
                                onClick: { sheetState.sort = option }
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            

            VStack(spacing: 0) {
                Divider()
                
                HStack(spacing: 16) {
                    Button(action: {
                        sheetState.clear(defaultPrice: defaultMaxPrice)
                    }) {
                        Text(String(localized: "deleteAll"))
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(isClearEnabled ? .primary : Color(.systemGray4))
                    }
                    .disabled(!isClearEnabled)
                    
                    Spacer()
                    
                    Button(action: {
                        onFilter(sheetState)
                    }) {
                        Text(String(localized: "showResults"))
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 24)
                            .background(isConfirmEnabled ? Color.primarySB : Color(.systemGray4))
                            .cornerRadius(50)
                    }
                    .disabled(!isConfirmEnabled)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
            }
        }
    }
}
