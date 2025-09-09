//
//  SearchUsernameMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import Foundation

extension SearchUsername {
    init(dto: SearchUsernameDTO) {
        self.available = dto.available
        self.suggestions = dto.suggestions
        self.username = dto.username
    }
}
