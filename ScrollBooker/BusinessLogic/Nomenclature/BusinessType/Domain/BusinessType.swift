//
//  BusinessType.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.07.2026.
//

import Foundation

struct BusinessType: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let plural: String
    let url: String?
    let thumbnailUrl: String?
    
    var webURL: URL? { url.flatMap(URL.init(string:)) }
    var thumbnailURL: URL? { thumbnailUrl.flatMap(URL.init(string:)) }
}
