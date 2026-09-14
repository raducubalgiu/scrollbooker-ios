//
//  NetworkMonitor.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation
import Network
import Observation

/// Monitorizează live conectivitatea la internet, independent de orice request
/// anume — stare globală, ambientală, consumată de `NetworkStatusBanner` la
/// rădăcina aplicației. Ecranele/ViewModel-urile individuale nu trebuie să
/// știe de conectivitate; mesajul lor de eroare rămâne generic.
@Observable
@MainActor
final class NetworkMonitor {
    private(set) var isConnected: Bool = true

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.scrollbooker.NetworkMonitor")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            Task { @MainActor [weak self] in
                self?.isConnected = connected
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
