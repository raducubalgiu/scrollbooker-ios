//
//  ViewModelCache.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.07.2026.
//

import SwiftUI

final class ViewModelCache<Key: Hashable, VM: AnyObject> {
    private var storage: [Key: VM] = [:]

    func viewModel(for key: Key, make: (Key) -> VM) -> VM {
        if let existing = storage[key] {
            return existing
        }
        let created = make(key)
        storage[key] = created
        return created
    }

    func evict(keysNotIn validKeys: Set<Key>) {
        storage = storage.filter { validKeys.contains($0.key) }
    }

    func evictAll() {
        storage.removeAll()
    }
}
