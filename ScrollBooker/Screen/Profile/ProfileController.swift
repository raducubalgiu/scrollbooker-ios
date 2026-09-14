//
//  ProfileController.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class ProfileController {
    private(set) var viewState: FeatureState<UserProfile> = .idle
    private(set) var isRefreshing: Bool = false
    var profileRefreshErrorMessage: String?

    private let pageLimit = 10

    var profile: UserProfile? { viewState.data }

    // --- POSTS ---
    private(set) var postsState: FeatureState<[Post]> = .idle
    private(set) var isPagingPosts: Bool = false

    private var postsPage = 1
    private var postsTotalCount = 0

    var hasMorePosts: Bool { (postsState.data?.count ?? 0) < postsTotalCount }

    // --- BOOKMARKS ---
    private(set) var bookmarksState: FeatureState<[Post]> = .idle
    private(set) var isPagingBookmarks: Bool = false

    private var bookmarksPage = 1
    private var bookmarksTotalCount = 0

    var hasMoreBookmarks: Bool { (bookmarksState.data?.count ?? 0) < bookmarksTotalCount }

    // --- PRODUCTS ---
    private(set) var productsState: FeatureState<UserProducts> = .idle

    // --- ABOUT ---
    private(set) var aboutState: FeatureState<UserProfileAbout> = .idle

    private let getUserProfileUseCase: GetUserProfileUseCase
    private let getUserProfileAboutUseCase: GetUserProfileAboutUseCase
    private let getUserPostsUseCase: GetUserPostsUseCase
    private let getUserBookmarkedPostsUseCase: GetUserBookmarkedPostsUseCase
    private let getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase

    init(
        getUserProfileUseCase: GetUserProfileUseCase,
        getUserProfileAboutUseCase: GetUserProfileAboutUseCase,
        getUserPostsUseCase: GetUserPostsUseCase,
        getUserBookmarkedPostsUseCase: GetUserBookmarkedPostsUseCase,
        getProductsByBusinessAndEmployeeUseCase: GetProductsbyBusinessAndEmployeeUseCase
    ) {
        self.getUserProfileUseCase = getUserProfileUseCase
        self.getUserProfileAboutUseCase = getUserProfileAboutUseCase
        self.getUserPostsUseCase = getUserPostsUseCase
        self.getUserBookmarkedPostsUseCase = getUserBookmarkedPostsUseCase
        self.getProductsByBusinessAndEmployeeUseCase = getProductsByBusinessAndEmployeeUseCase
    }

    // MARK: - Profile (initial load, once)
    func fetchProfile(username: String) async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }

        viewState = .loading

        do {
            let result = try await withLoading {
                try await getUserProfileUseCase(username: username)
            }
            viewState = .success(result)
        } catch {
            viewState = .error(error.readableMessage)
        }
    }

    private func performProfileRefresh(username: String) async {
        do {
            let result = try await getUserProfileUseCase(username: username)
            viewState = .success(result)
        } catch {
            guard !error.isCancellation else { return }

            if viewState.data == nil {
                viewState = .error(error.readableMessage)
            } else {
                profileRefreshErrorMessage = error.readableMessage
            }
        }
    }

    /// Updates the cached profile in place (e.g. after an edit-profile save), without a refetch.
    func updateProfile(_ profile: UserProfile) {
        viewState = .success(profile)
    }

    // MARK: - Posts
    func loadInitialPosts(userId: Int) async {
        guard postsState == .idle else { return }
        await loadPostsData(userId: userId, isFirstPage: true)
    }

    func loadMorePostsIfNeeded(userId: Int, currentPost: Post?) async {
        guard hasMorePosts, !isPagingPosts else { return }
        guard let current = currentPost, current.id == postsState.data?.last?.id else { return }

        isPagingPosts = true
        await loadPostsData(userId: userId, isFirstPage: false)
        isPagingPosts = false
    }

    private func refreshPosts(userId: Int) async {
        postsPage = 1
        await loadPostsData(userId: userId, isFirstPage: true)
    }

    private func loadPostsData(userId: Int, isFirstPage: Bool) async {
        if isFirstPage && !isRefreshing {
            postsState = .loading
        }

        do {
            let response = try await withLoading {
                try await getUserPostsUseCase(userId: userId, page: postsPage, limit: pageLimit)
            }
            let existingData = postsState.data ?? []
            let newData: [Post]

            if isFirstPage {
                newData = response.results
            } else {
                let existingIds = Set(existingData.map(\.id))
                newData = existingData + response.results.filter { !existingIds.contains($0.id) }
            }

            postsTotalCount = response.count
            postsPage += 1
            postsState = .success(newData)
        } catch {
            guard !error.isCancellation else { return }

            if isFirstPage {
                postsState = .error(error.readableMessage)
            } else {
                print("Eroare paginare profil (posts): \(error.readableMessage)")
            }
        }
    }

    // MARK: - Bookmarks
    func loadInitialBookmarks(userId: Int) async {
        guard bookmarksState == .idle else { return }
        await loadBookmarksData(userId: userId, isFirstPage: true)
    }

    func loadMoreBookmarksIfNeeded(userId: Int, currentPost: Post?) async {
        guard hasMoreBookmarks, !isPagingBookmarks else { return }
        guard let current = currentPost, current.id == bookmarksState.data?.last?.id else { return }

        isPagingBookmarks = true
        await loadBookmarksData(userId: userId, isFirstPage: false)
        isPagingBookmarks = false
    }

    private func refreshBookmarks(userId: Int) async {
        bookmarksPage = 1
        await loadBookmarksData(userId: userId, isFirstPage: true)
    }

    private func loadBookmarksData(userId: Int, isFirstPage: Bool) async {
        if isFirstPage && !isRefreshing {
            bookmarksState = .loading
        }

        do {
            let response = try await withLoading {
                try await getUserBookmarkedPostsUseCase(userId: userId, page: bookmarksPage, limit: pageLimit)
            }
            let existingData = bookmarksState.data ?? []
            let newData: [Post]

            if isFirstPage {
                newData = response.results
            } else {
                let existingIds = Set(existingData.map(\.id))
                newData = existingData + response.results.filter { !existingIds.contains($0.id) }
            }

            bookmarksTotalCount = response.count
            bookmarksPage += 1
            bookmarksState = .success(newData)
        } catch {
            guard !error.isCancellation else { return }

            if isFirstPage {
                bookmarksState = .error(error.readableMessage)
            } else {
                print("Eroare paginare profil (bookmarks): \(error.readableMessage)")
            }
        }
    }

    // MARK: - Products
    func loadInitialProducts(businessId: Int, employeeId: Int?) async {
        guard productsState == .idle else { return }
        await loadProductsData(businessId: businessId, employeeId: employeeId)
    }

    private func refreshProducts(businessId: Int, employeeId: Int?) async {
        await loadProductsData(businessId: businessId, employeeId: employeeId)
    }

    private func loadProductsData(businessId: Int, employeeId: Int?) async {
        if !isRefreshing { productsState = .loading }

        do {
            let response = try await withLoading {
                try await getProductsByBusinessAndEmployeeUseCase(
                    businessId: businessId,
                    employeeId: employeeId,
                    onlyServicesWithProducts: true,
                    productsLimitPerService: 5
                )
            }
            productsState = .success(response)
        } catch {
            productsState = .error(error.readableMessage)
        }
    }

    // MARK: - About
    func loadInitialAbout(userId: Int) async {
        guard aboutState == .idle else { return }
        await loadAboutData(userId: userId)
    }

    private func refreshAbout(userId: Int) async {
        await loadAboutData(userId: userId)
    }

    private func loadAboutData(userId: Int) async {
        if !isRefreshing { aboutState = .loading }

        do {
            let response = try await withLoading {
                try await getUserProfileAboutUseCase(userId: userId)
            }
            aboutState = .success(response)
        } catch {
            aboutState = .error(error.readableMessage)
        }
    }

    // MARK: - Tab orchestration
    private func employeeId(for userId: Int) -> Int? {
        guard let profile else { return nil }
        let isEmployee = profile.isBusinessOrEmployee && profile.id != profile.businessOwner?.id
        return isEmployee ? userId : nil
    }

    func loadTabContentIfNeeded(_ tab: ProfileTab, userId: Int) async {
        switch tab {
        case .posts:
            await loadInitialPosts(userId: userId)
        case .products:
            await loadInitialProducts(businessId: userId, employeeId: employeeId(for: userId))
        case .about:
            await loadInitialAbout(userId: userId)
        case .bookmarks:
            await loadInitialBookmarks(userId: userId)
        case .employees:
            break
        }
    }

    private func refreshTab(_ tab: ProfileTab, userId: Int) async {
        switch tab {
        case .posts:
            await refreshPosts(userId: userId)
        case .products:
            await refreshProducts(businessId: userId, employeeId: employeeId(for: userId))
        case .about:
            await refreshAbout(userId: userId)
        case .bookmarks:
            await refreshBookmarks(userId: userId)
        case .employees:
            break
        }
    }

    // MARK: - Refresh unificat (silent — profil + tab activ, in paralel)
    func refresh(username: String, userId: Int, activeTab: ProfileTab) async {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }

        profileRefreshErrorMessage = nil

        async let profileRefresh: () = performProfileRefresh(username: username)
        async let tabRefresh: () = refreshTab(activeTab, userId: userId)
        _ = await (profileRefresh, tabRefresh)
    }

    func reset() {
        viewState = .idle
        profileRefreshErrorMessage = nil
        postsState = .idle; postsPage = 1; postsTotalCount = 0
        bookmarksState = .idle; bookmarksPage = 1; bookmarksTotalCount = 0
        productsState = .idle
        aboutState = .idle
    }
}

private extension Error {
    var isCancellation: Bool {
        if self is CancellationError { return true }
        if let urlError = self as? URLError, urlError.code == .cancelled { return true }
        return false
    }

    var readableMessage: String {
        (self as? LocalizedError)?.errorDescription ?? localizedDescription
    }
}
