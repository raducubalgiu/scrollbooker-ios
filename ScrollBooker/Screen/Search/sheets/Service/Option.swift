//
//  Option.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import Foundation

struct Option: Identifiable {
    let id = UUID()
    let value: String
    let name: String
    var description: String? = nil
}
