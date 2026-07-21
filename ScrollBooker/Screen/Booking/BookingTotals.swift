//
//  BookingTotals.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import Foundation

struct BookingTotals: Equatable {
    let totalPrice: Decimal
    let totalDuration: Int
    
    static func == (lhs: BookingTotals, rhs: BookingTotals) -> Bool {
        return lhs.totalDuration == rhs.totalDuration &&
               lhs.totalPrice == rhs.totalPrice
    }
}
