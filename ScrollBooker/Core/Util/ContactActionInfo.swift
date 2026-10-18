//
//  ContactActionInfo.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.10.2026.
//

import Foundation

struct ContactActionInfo {
    let title: String
    let isWhatsAppStyled: Bool
    let onClick: () -> Void

    var isVisible: Bool { !title.isEmpty }

    init(contact: ContactInfo, onOpenContactSheet: @escaping () -> Void) {
        switch (contact.acceptsWhatsapp, contact.acceptsCalls) {
        case (true, true):
            title = String(localized: "contactUs")
            isWhatsAppStyled = false
            onClick = onOpenContactSheet

        case (true, false):
            title = String(localized: "WhatsApp")
            isWhatsAppStyled = true
            onClick = {
                guard let phone = contact.phone else { return }
                ContactActionHelper.openWhatsApp(phone: phone)
            }

        case (false, true):
            title = String(localized: "call")
            isWhatsAppStyled = false
            onClick = {
                guard let phone = contact.phone else { return }
                ContactActionHelper.call(phone: phone)
            }

        case (false, false):
            title = ""
            isWhatsAppStyled = false
            onClick = {}
        }
    }
}
