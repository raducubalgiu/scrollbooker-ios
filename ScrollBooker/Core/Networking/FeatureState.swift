//
//  FeatureState.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.07.2026.
//

enum FeatureState<T: Equatable>: Equatable {
    case idle
    case loading
    case success(T)
    case error(String)
    
    var data: T? {
        if case .success(let data) = self { return data }
        return nil
    }
}
