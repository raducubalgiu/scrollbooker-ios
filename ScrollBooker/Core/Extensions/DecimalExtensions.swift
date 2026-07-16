//
//  DecimalExtensions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

extension Decimal {
    func toTwoDecimals() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.roundingMode = .halfUp
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter.string(from: self as NSDecimalNumber) ?? String(describing: self)
    }
    
    func toFixedDecimals(decimals: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals
        formatter.roundingMode = .halfUp
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter.string(from: self as NSDecimalNumber) ?? String(describing: self)
    }
}
