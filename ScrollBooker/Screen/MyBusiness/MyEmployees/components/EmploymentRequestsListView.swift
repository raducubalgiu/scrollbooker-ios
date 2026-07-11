//
//  EmploymentRequestsList.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct EmploymentRequestsListView: View {
    let requests: [EmploymentRequest]
    let onRequestClick: (Int) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(requests) { request in
                    EmploymentRequestCardView(
                        employmentRequest: request,
                        onClick: { id in
                            onRequestClick(id)
                        }
                    )
                }
            }
            .padding(.top, 16)
        }
    }
}
