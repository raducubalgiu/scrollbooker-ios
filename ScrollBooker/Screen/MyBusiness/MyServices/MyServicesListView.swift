//
//  MyServicesListView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct MyServicesListView: View {
    let data: [SelectedServiceDomainsWithServices]
    let selectedServiceIds: Set<Int>
    var onToggleService: (Int) -> Void
    
    @State private var expandedCategories: [Int: Bool] = [:]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(data) { category in
                    
                    let isExpandedBinding = Binding<Bool>(
                        get: { expandedCategories[category.id, default: true] },
                        set: { expandedCategories[category.id] = $0 }
                    )
                    
                    DisclosureGroup(isExpanded: isExpandedBinding) {
                        VStack(spacing: 0) {
                            ForEach(category.services) { service in
                                InputCheckbox(
                                    headLine: service.name,
                                    checked: selectedServiceIds.contains(service.id),
                                    onCheckedChange: {
                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                            onToggleService(service.id)
                                        }
                                    }
                                )
                                
                                if service.id != category.services.last?.id {
                                    Divider()
                                        .opacity(0.5)
                                        .padding(.horizontal, .xxl)
                                        .padding(.vertical, .base)
                                }
                            }
                        }
                        .padding(.top, .xl)
                    } label: {
                        Text(category.name)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color.surfaceSB)
                    .cornerRadius(12)
                }
            }
            .padding(.vertical, .s)
        }
    }
}
