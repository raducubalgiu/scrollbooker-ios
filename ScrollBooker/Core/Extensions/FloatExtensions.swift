//
//  FloatExtensions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation

extension Float {
    func formatRating() -> String {
        let formattedWithDot = self.toFixedDecimals(decimals: 1)
        return formattedWithDot.replacingOccurrences(of: ".", with: ",")
    }
    
    func toDecimals(decimals: Int = 2) -> String {
        guard self.isFinite else { return String(self) }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = 0
        formatter.roundingMode = .halfUp
        formatter.locale = Locale(identifier: "en_US")
        
        let number = NSNumber(value: self)
        return formatter.string(from: number) ?? String(self)
    }
    
    func toFixedDecimals(decimals: Int = 2) -> String {
        guard self.isFinite else { return String(self) }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals
        formatter.roundingMode = .halfUp
        formatter.locale = Locale(identifier: "en_US")
        
        let number = NSNumber(value: self)
        return formatter.string(from: number) ?? String(self)
    }
}
