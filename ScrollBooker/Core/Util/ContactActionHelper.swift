//
//  ContactActionHelper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.10.2026.
//

import Foundation
import UIKit

enum ContactActionHelper {
    static func openWhatsApp(phone: String) {
        let digits = phone.hasPrefix("+") ? String(phone.dropFirst()) : phone
        guard let url = URL(string: "https://wa.me/\(digits)") else { return }
        UIApplication.shared.open(url)
    }

    static func call(phone: String) {
        let digits = phone.filter { $0.isNumber || $0 == "+" }
        guard let url = URL(string: "tel://\(digits)") else { return }
        UIApplication.shared.open(url)
    }
}
