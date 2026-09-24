//
//  GoogleAuthRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

struct GoogleAuthRequest: Encodable, Sendable {
    let idToken: String
    let roleName: String?
    
    enum CodingKeys: String, CodingKey {
        case idToken = "id_token"
        case roleName = "role_name"
    }
}
