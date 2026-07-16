//
//  IntExtensions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

extension Int {
    func formatDuration(padMinutes: Bool = false) -> String {
        let total = Swift.max(0, self)
        let hours = total / 60
        let minutes = total % 60

        if hours == 0 {
            return "\(minutes)min"
        } else {
            if minutes == 0 {
                return "\(hours)h"
            } else {
                let mins: String
                if padMinutes && minutes < 10 {
                    mins = "0\(minutes)"
                } else {
                    mins = "\(minutes)"
                }
                
                return "\(hours)h \(mins)min"
            }
        }
    }
}
