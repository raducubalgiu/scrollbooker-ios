//
//  ProfilePostSource.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import Foundation

/// Which of `ProfileController`'s two already-loaded lists a `ProfilePostDetailViewModel`
/// should page through — the Posts grid or the Bookmarks grid.
enum ProfilePostSource: Hashable {
    case posts
    case bookmarks
}
