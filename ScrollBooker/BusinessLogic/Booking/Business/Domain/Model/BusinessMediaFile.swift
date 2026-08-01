//
//  BusinessMediaFile.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

struct BusinessMediaFile: Identifiable, Equatable, Hashable, Sendable {
    var id: String { urlKey } 
    
    let url: String
    let urlKey: String
    let thumbnailUrl: String
    let thumbnailKey: String
    let type: String
    let orderIndex: Int
    
    var thumbnailURL: URL? { URL(string: thumbnailUrl) }
    var mediaURL: URL? { URL(string: url) }
}
