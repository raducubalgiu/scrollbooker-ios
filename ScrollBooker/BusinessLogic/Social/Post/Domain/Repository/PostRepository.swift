//
//  PostRepository.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 23.07.2026.
//

protocol PostRepository: Sendable {
    func getExplorePosts(page: Int, limit: Int) async throws -> PaginatedResponse<Post>
    func getFollowingPosts(page: Int, limit: Int) async throws -> PaginatedResponse<Post>
    func getVideoReviews(userId: Int, page: Int, limit: Int) async throws -> PaginatedResponse<Post>
    func likePost(id: Int) async throws -> NoContent
    func unlikePost(id: Int) async throws -> NoContent
    func bookmarkPost(id: Int) async throws -> NoContent
    func unbookmarkPost(id: Int) async throws -> NoContent
}
