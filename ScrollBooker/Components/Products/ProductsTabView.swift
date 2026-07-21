//
//  ProductsTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ProductsTabsView: View {
    @Binding var activeSectionId: Int?
    let serviceGroups: [BusinessServicesWithProducts]
    let proxy: ScrollViewProxy
    
    var body: some View {
        let fallbackId = serviceGroups.first?.service.id ?? 0
        
        BookingServicesTabs(
            activeSectionId: activeSectionId ?? fallbackId,
            serviceGroups: serviceGroups
        ) { clickedTabId in
            withAnimation(.easeInOut(duration: 0.3)) {
                activeSectionId = clickedTabId
                proxy.scrollTo(clickedTabId, anchor: .top)
            }
        }
    }
}
