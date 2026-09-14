//
//  PermissionMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

extension Permission {
    init(dto: PermissionDTO) {
        self.code = dto.code
    }
}
