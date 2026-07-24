//
//  FollowingTabViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class FollowingTabViewModel: BaseFeedViewModel {
    private let getFollowingPostsUseCase: GetFollowingPostsUseCase

    init(getFollowingPostsUseCase: GetFollowingPostsUseCase) {
        self.getFollowingPostsUseCase = getFollowingPostsUseCase
        super.init()
    }

    func initialLoad() async {
        await initialLoadIfNeeded { page, limit in
            try await self.getFollowingPostsUseCase(page: page, limit: limit)
        }
    }

    func refreshPosts() async {
        await refresh { page, limit in
            try await self.getFollowingPostsUseCase(page: page, limit: limit)
        }
    }

    func loadMore(currentPost: Post?) async {
        await loadMoreIfNeeded(currentPost: currentPost) { page, limit in
            try await self.getFollowingPostsUseCase(page: page, limit: limit)
        }
    }
}
