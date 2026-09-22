//
//  ShareCannelEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import SwiftUI
import UIKit

enum ShareChannelEnum: String, CaseIterable, Identifiable, Codable {
    case whatsapp = "whatsapp"
    case facebook = "facebook"
    case instagram = "instagram"
    case tiktok = "tiktok"
    case messenger = "messenger"
    case sms = "sms"
    case email = "email"
    case copyLink = "copy_link"
    case other = "other"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .whatsapp: return "phone.circle.fill"
        case .facebook: return "f.circle.fill"
        case .instagram: return "camera.circle.fill"
        case .tiktok: return "music.note"
        case .messenger: return "bubble.left.and.bubble.right.fill"
        case .sms: return "message.fill"
        case .email: return "envelope.fill"
        case .copyLink: return "doc.on.doc.fill"
        case .other: return "square.and.arrow.up"
        }
    }
    
    var displayName: String {
        switch self {
        case .whatsapp: return "WhatsApp"
        case .facebook: return "Facebook"
        case .instagram: return "Instagram"
        case .tiktok: return "TikTok"
        case .messenger: return "Messenger"
        case .sms: return "SMS"
        case .email: return "Email"
        case .copyLink: return "Copiază link"
        case .other: return "Altele"
        }
    }
}

extension ShareChannelEnum {
    static func from(activityType: UIActivity.ActivityType?) -> ShareChannelEnum {
        guard let activityType = activityType else { return .other }

        switch activityType {
        case .mail:
            return .email
        case .message:
            return .sms
        case .postToFacebook:
            return .facebook
        case .copyToPasteboard:
            return .copyLink
        default:
            let rawString = activityType.rawValue.lowercased()
            if rawString.contains("whatsapp") { return .whatsapp }
            if rawString.contains("instagram") { return .instagram }
            if rawString.contains("tiktok") { return .tiktok }
            if rawString.contains("messenger") { return .messenger }
            
            return .other
        }
    }
}

