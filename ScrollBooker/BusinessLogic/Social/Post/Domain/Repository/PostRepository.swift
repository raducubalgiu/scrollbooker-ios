//
//  PostRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

protocol PostRepository: Sendable {
    func getExplorePosts(page: Int, limit: Int, serviceIds: [Int], onlyVideoReviews: Bool) async throws -> PaginatedResponse<Post>
    func getFollowingPosts(page: Int, limit: Int) async throws -> PaginatedResponse<Post>
    func getVideoReviews(businessId: Int, employeeId: Int?, ratings: [Int]?, page: Int, limit: Int) async throws -> PaginatedResponse<Post>
    func getUserPosts(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<Post>
    func getUserBookmarkedPosts(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<Post>
    func getPostAnalyticsSummary(postId: Int) async throws -> PostAnalyticsSummary
    func deletePost(id: Int) async throws -> NoContent
    func likePost(id: Int) async throws -> NoContent
    func unlikePost(id: Int) async throws -> NoContent
    func bookmarkPost(id: Int) async throws -> NoContent
    func unbookmarkPost(id: Int) async throws -> NoContent
    func createPost(request: CreatePostRequest) async throws -> NoContent
}
