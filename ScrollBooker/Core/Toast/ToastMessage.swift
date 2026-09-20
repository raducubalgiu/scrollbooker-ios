//
//  ToastMessage.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.09.2026.
//

import Foundation

enum ToastType: Equatable {
    case `default`
    case error
}

struct ToastMessage: Identifiable, Equatable {
    let id = UUID()
    let message: String
    var type: ToastType = .default
}
