//
//  ShareUtils.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import UIKit

final class ShareHelper {
    private static let shareBaseURL = "https://scrollbooker-web.vercel.app"
    
    @MainActor
    private static func presentChooser(
        text: String?,
        url: URL,
        onChannelResolved: @escaping (ShareChannelEnum) -> Void
    ) {
        var items: [Any] = [url]
        if let text = text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            items.insert("\(text)\n", at: 0)
        }
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = { activityType, completed, _, _ in
            if completed {
                let resolvedChannel = ShareChannelEnum.from(activityType: activityType)
                onChannelResolved(resolvedChannel)
            }
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = rootVC.view
                popover.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: rootVC.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @MainActor
    static func sharePost(
        post: Post,
        onChannelResolved: @escaping (ShareChannelEnum) -> Void
    ) {
        let professionSlug = post.user.profession.toSlug()
        let postUrlString = "\(shareBaseURL)/user/\(post.user.username)/\(professionSlug)/post/\(post.id)"
        guard let url = URL(string: postUrlString) else { return }
        
        presentChooser(text: post.description, url: url, onChannelResolved: onChannelResolved)
    }
    
    @MainActor
    static func shareUserProfile(
        username: String,
        profession: String,
        bio: String?,
        onChannelResolved: @escaping (ShareChannelEnum) -> Void
    ) {
        let professionSlug = profession.toSlug()
        let userUrlString = "\(shareBaseURL)/user/\(username)/\(professionSlug)"
        guard let url = URL(string: userUrlString) else { return }
        
        presentChooser(text: bio, url: url, onChannelResolved: onChannelResolved)
    }
    
    @MainActor
    static func shareBusinessProfile(
        businessOwnerUsername: String,
        businessOwnerProfession: String,
        businessDescription: String?,
        onChannelResolved: @escaping (ShareChannelEnum) -> Void
    ) {
        let professionSlug = businessOwnerProfession.toSlug()
        let businessUrlString = "\(shareBaseURL)/business/\(professionSlug)/\(businessOwnerUsername)"
        guard let url = URL(string: businessUrlString) else { return }
        
        presentChooser(text: businessDescription, url: url, onChannelResolved: onChannelResolved)
    }
}
