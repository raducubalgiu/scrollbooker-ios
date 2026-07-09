//
//  ViewExtensions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import SwiftUI

extension View {
    func hideSystemBars() -> some View {
        self
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .tabBar)
    }
}
