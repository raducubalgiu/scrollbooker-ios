//
//  ToastCenter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.09.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class ToastCenter {
    private(set) var currentToast: ToastMessage?
    private var dismissTask: Task<Void, Never>?

    func show(_ message: String, type: ToastType = .default, duration: Duration = .seconds(2)) {
        dismissTask?.cancel()
        currentToast = ToastMessage(message: message, type: type)

        dismissTask = Task {
            try? await Task.sleep(for: duration)
            guard !Task.isCancelled else { return }
            currentToast = nil
        }
    }

    func dismiss() {
        dismissTask?.cancel()
        currentToast = nil
    }
}
