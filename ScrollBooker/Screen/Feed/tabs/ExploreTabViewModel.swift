//
//  ExploreTabViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class ExploreTabViewModel: BaseFeedViewModel {
    private let getExplorePostsUseCase: GetExplorePostsUseCase

    init(getExplorePostsUseCase: GetExplorePostsUseCase) {
        self.getExplorePostsUseCase = getExplorePostsUseCase
        super.init()
    }

    func initialLoad() async {
        await initialLoadIfNeeded { page, limit in
            try await self.getExplorePostsUseCase(page: page, limit: limit)
        }
    }

    func refreshPosts() async {
        await refresh { page, limit in
            try await self.getExplorePostsUseCase(page: page, limit: limit)
        }
    }

    func loadMore(currentPost: Post?) async {
        await loadMoreIfNeeded(currentPost: currentPost) { page, limit in
            try await self.getExplorePostsUseCase(page: page, limit: limit)
        }
    }
}
