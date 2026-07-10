//
//  AppointmentDetailsActions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import SwiftUI

struct AppointmentDetailsActions: View {
    let appointmentId: Int
    let status: AppointmentStatusEnum
    let isCustomer: Bool
    var onOpenCancelSheet: (Int) -> Void
    
    var body: some View {
        VStack {
            switch status {
            case .inProgress:
                MainButton(
                    title: String(localized: "cancel"),
                    onClick: {
                        onOpenCancelSheet(appointmentId)
                    },
                    bgColor: .errorSB
                )
            case .finished:
                if isCustomer {
                    MainButton(
                        title: String(localized: "bookAgain"),
                        onClick: {}
                    )
                }
            default:
                EmptyView()
            }
        }
    }
}
