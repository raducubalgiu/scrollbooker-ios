//
//  RecommendedBusiness.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import Foundation
import SwiftUI

struct RecommendedBusiness: Identifiable, Codable, Hashable {
    let id: Int
    let user: UserMini
    let distance: Float
    let isOpen: Bool
}
