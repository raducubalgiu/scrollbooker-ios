//
//  SelectedServiceDomainsWithServices.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

struct SelectedServiceDomainsWithServices: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let services: [SelectedService]
}

struct SelectedService: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let shortName: String
    let isSelected: Bool
}
