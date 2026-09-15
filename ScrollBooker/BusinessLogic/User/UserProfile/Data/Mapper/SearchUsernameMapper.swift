//
//  SearchUsernameMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import Foundation

extension SearchUsername {
    // Backend-ul nu ecouă username-ul căutat în răspuns — îl atașăm noi local,
    // la fel ca pe Android, ca ecranul să poată verifica dacă rezultatul mai e
    // valabil pentru textul curent din input (evită race condition la debounce).
    init(dto: SearchUsernameDTO, username: String) {
        self.available = dto.available
        self.suggestions = dto.suggestions
        self.username = username
    }
}
