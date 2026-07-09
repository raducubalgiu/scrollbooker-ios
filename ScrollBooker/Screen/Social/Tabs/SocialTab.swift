//
//  SocialTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

enum SocialTab: String, CaseIterable, Identifiable {
    case reviews = "Recenzii"
    case followers = "Urmăritori"
    case following = "Urmărești"

    var id: String { rawValue }
}
