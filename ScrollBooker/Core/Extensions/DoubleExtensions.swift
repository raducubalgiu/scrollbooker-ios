//
//  DoubleExtensions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 08.10.2026.
//

import Foundation

extension Double {
    func formatDistance() -> String {
        if self < 0.5 { return "<500m" }
        if self < 1 { return "\(Int(self * 1000))m" }
        if self.truncatingRemainder(dividingBy: 1) < 0.05 { return "\(Int(self))km" }
        return String(format: "%.1fkm", self)
    }
}
