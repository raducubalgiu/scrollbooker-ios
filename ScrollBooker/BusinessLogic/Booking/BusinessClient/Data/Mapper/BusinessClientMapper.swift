//
//  BusinessClientMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 22.09.2026.
//

import Foundation

extension BusinessClientDTO {
    func toDomain() -> BusinessClient {
        BusinessClient(
            id: id,
            businessId: businessId,
            userId: userId,
            fullname: fullname,
            phone: phone
        )
    }
}
