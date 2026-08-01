//
//  ProfileController.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import Foundation
import Observation

enum PostsState {
    case idle
    case loading
    case empty
    case success([Post])
    case error(String)

    var errorMessage: String? { if case .error(let msg) = self { return msg }; return nil }
}

enum ProfileProductsState {
    case idle
    case loading
    case success(UserProducts)
    case error(String)

    var errorMessage: String? { if case .error(let msg) = self { return msg }; return nil }
}

enum ProfileAboutState {
    case idle
    case loading
    case success(UserProfileAbout)
    case error(String)

    var errorMessage: String? { if case .error(let msg) = self { return msg }; return nil }
}

@Observable
@MainActor
final class ProfileController: HasLoadingState {
    var uiState = UiState(data: UserProfile?.none)
    private(set) var viewState: ProfileState = .idle

    private let pageLimit = 10

    // --- POSTS ---
    private(set) var posts: [Post] = []
    private(set) var postsViewState: PostsState = .idle
    private(set) var isPagingPosts: Bool = false

    private var postsPage = 1
    private var postsTotalCount = 0

    var hasMorePosts: Bool { posts.count < postsTotalCount }

    // --- BOOKMARKS ---
    private(set) var bookmarkedPosts: [Post] = []
    private(set) var bookmarksViewState: PostsState = .idle
    private(set) var isPagingBookmarks: Bool = false

    private var bookmarksPage = 1
    private var bookmarksTotalCount = 0

    var hasMoreBookmarks: Bool { bookmarkedPosts.count < bookmarksTotalCount }

    // --- PRODUCTS ---
    private(set) var productsData: UserProducts? = nil
    private(set) var productsViewState: ProfileProductsState = .idle

    // --- ABOUT ---
    private(set) var aboutData: UserProfileAbout? = nil
    private(set) var aboutViewState: ProfileAboutState = .idle


    var isLoading: Bool {
        get { uiState.isLoading }
        set { uiState.isLoading = newValue }
    }

    var errorMessage: String? {
        get { uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }

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

    // MARK: - Profile (initial load)
    func fetchProfile(username: String, hasMinLoading: Bool = false) async {
        guard uiState.data == nil else { return }
        guard viewState != .loading else { return }

        if hasMinLoading {
            await withVisibleLoading { await performFetch(username: username) }
        } else {
            await performFetch(username: username)
        }
    }

    private func performFetch(username: String) async {
        viewState = .loading
        uiState.errorMessage = nil

        do {
            let result = try await getUserProfileUseCase(username: username)
            uiState.data = result
            viewState = .success(result)
        } catch {
            viewState = .error(error.readableMessage)
        }
    }

    private func performProfileRefresh(username: String) async {
        do {
            let result = try await getUserProfileUseCase(username: username)
            uiState.data = result
            viewState = .success(result)
        } catch {
            guard !error.isCancellation else { return }
            if uiState.data == nil {
                viewState = .error(error.readableMessage)
            } else {
                uiState.errorMessage = error.readableMessage
            }
        }
    }

    // MARK: - Posts
    func loadInitialPosts(userId: Int) async {
        guard posts.isEmpty else { return }
        await loadPostsData(userId: userId, isFirstPage: true)
    }

    func loadMorePostsIfNeeded(userId: Int, currentPost: Post?) async {
        guard hasMorePosts, !isPagingPosts else { return }
        guard let current = currentPost, current.id == posts.last?.id else { return }

        isPagingPosts = true
        await loadPostsData(userId: userId, isFirstPage: false)
        isPagingPosts = false
    }

    private func refreshPosts(userId: Int) async {
        postsPage = 1
        await loadPostsData(userId: userId, isFirstPage: true)
    }

    private func loadPostsData(userId: Int, isFirstPage: Bool) async {
        if isFirstPage && !uiState.isRefreshing {
            postsViewState = .loading
        }

        do {
            let response = try await getUserPostsUseCase(userId: userId, page: postsPage, limit: pageLimit)

            if isFirstPage {
                posts = response.results
            } else {
                let existingIds = Set(posts.map(\.id))
                posts.append(contentsOf: response.results.filter { !existingIds.contains($0.id) })
            }

            postsTotalCount = response.count
            postsPage += 1
            postsViewState = posts.isEmpty ? .empty : .success(posts)
        } catch {
            guard !error.isCancellation else { return }
            
            if isFirstPage {
                postsViewState = .error(error.readableMessage)
            } else {
                print("Eroare paginare profil (posts): \(error.readableMessage)")
            }
        }
    }

    // MARK: - Bookmarks
    func loadInitialBookmarks(userId: Int) async {
        guard bookmarkedPosts.isEmpty else { return }
        await loadBookmarksData(userId: userId, isFirstPage: true)
    }

    func loadMoreBookmarksIfNeeded(userId: Int, currentPost: Post?) async {
        guard hasMoreBookmarks, !isPagingBookmarks else { return }
        guard let current = currentPost, current.id == bookmarkedPosts.last?.id else { return }

        isPagingBookmarks = true
        await loadBookmarksData(userId: userId, isFirstPage: false)
        isPagingBookmarks = false
    }

    private func refreshBookmarks(userId: Int) async {
        bookmarksPage = 1
        await loadBookmarksData(userId: userId, isFirstPage: true)
    }

    private func loadBookmarksData(userId: Int, isFirstPage: Bool) async {
        if isFirstPage && !uiState.isRefreshing {
            bookmarksViewState = .loading
        }

        do {
            let response = try await withVisibleLoading {
                try await getUserBookmarkedPostsUseCase(
                    userId: userId,
                    page: bookmarksPage,
                    limit: pageLimit
                )
            }

            if isFirstPage {
                bookmarkedPosts = response.results
            } else {
                let existingIds = Set(bookmarkedPosts.map(\.id))
                bookmarkedPosts.append(contentsOf: response.results.filter { !existingIds.contains($0.id) })
            }

            bookmarksTotalCount = response.count
            bookmarksPage += 1
            bookmarksViewState = bookmarkedPosts.isEmpty ? .empty : .success(bookmarkedPosts)
        } catch {
            guard !error.isCancellation else { return }
            
            if isFirstPage {
                bookmarksViewState = .error(error.readableMessage)
            } else {
                print("Eroare paginare profil (bookmarks): \(error.readableMessage)")
            }
        }
    }

    // MARK: - Products
    func loadInitialProducts(businessId: Int, employeeId: Int?) async {
        guard productsData == nil else { return }
        await loadProductsData(businessId: businessId, employeeId: employeeId)
    }

    private func refreshProducts(businessId: Int, employeeId: Int?) async {
        await loadProductsData(businessId: businessId, employeeId: employeeId)
    }

    private func loadProductsData(businessId: Int, employeeId: Int?) async {
        if !uiState.isRefreshing { productsViewState = .loading }

        do {
            let response = try await withVisibleLoading {
                try await getProductsByBusinessAndEmployeeUseCase(
                    businessId: businessId,
                    employeeId: employeeId,
                    onlyServicesWithProducts: true,
                    productsLimitPerService: 5
                )
            }
            productsData = response
            productsViewState = .success(response)
        } catch {
            productsViewState = .error(error.readableMessage)
        }
    }

    // MARK: - About
    func loadInitialAbout(userId: Int) async {
        guard aboutData == nil else { return }
        await loadAboutData(userId: userId)
    }

    private func refreshAbout(userId: Int) async {
        await loadAboutData(userId: userId)
    }

    private func loadAboutData(userId: Int) async {
        if !uiState.isRefreshing { aboutViewState = .loading }

        do {
            let response = try await withVisibleLoading {
                try await getUserProfileAboutUseCase(userId: userId)
            }
            
            aboutData = response
            aboutViewState = .success(response)
        } catch {
            aboutViewState = .error(error.readableMessage)
        }
    }

    // MARK: - Tab orchestration
    private func employeeId(for userId: Int) -> Int? {
        guard let data = uiState.data else { return nil }
        let isEmployee = data.isBusinessOrEmployee && data.id != data.businessOwner?.id
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
        guard !uiState.isRefreshing else { return }
        uiState.isRefreshing = true
        defer { uiState.isRefreshing = false }

        async let profileRefresh: () = performProfileRefresh(username: username)
        async let tabRefresh: () = refreshTab(activeTab, userId: userId)
        _ = await (profileRefresh, tabRefresh)
    }

    func reset() {
        uiState = UiState(data: UserProfile?.none)
        viewState = .idle
        posts = []; postsViewState = .idle; postsPage = 1; postsTotalCount = 0
        bookmarkedPosts = []; bookmarksViewState = .idle; bookmarksPage = 1; bookmarksTotalCount = 0
        productsData = nil; productsViewState = .idle
        aboutData = nil; aboutViewState = .idle
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
