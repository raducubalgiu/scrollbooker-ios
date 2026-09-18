//
//  ReviewTab.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

enum ReviewTab: String, CaseIterable, Identifiable {
    case all = "Toate"
    case video = "Video"

    var id: String { rawValue }
}

