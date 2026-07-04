//
//  AppointmentsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation

@MainActor
final class AppointmentsViewModel: ObservableObject, HasLoadingState {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - UI State
    @Published private(set) var isRefreshing: Bool = false
    @Published var isInitialLoading = false
    private var didInitialLoading = false
    
    @Published private(set) var appointments: [Appointment] = []
    
    // MARK: - Deps
    private let api: AppointmentAPI
    private let session: SessionManager
    
    // MARK: - Paging
    private var page = 1
    private let limit = 10
    private var count = 0
    
    var hasMore: Bool { appointments.count < count }
    
    init(api: AppointmentAPI, session: SessionManager) {
        self.api = api
        self.session = session
    }
    
    // MARK: - Public
    func initialLoadIfNeeded() async {
        guard !didInitialLoading else { return }
        isInitialLoading = true
        
        defer {
            isInitialLoading = false
            didInitialLoading = true
        }
        appointments.removeAll()
        page = 1
        await loadAppointments()
    }
    
    private func loadAppointments() async {
        // SOLUȚIE ENTERPRISE: Am eliminat verificarea manuală a token-ului din SessionManager.
        // Interceptorul global se ocupă de validare și refresh automat.
        errorMessage = nil
        
        do {
            // Apelul curat către API, fără parametrul bearer.
            let response: PaginatedResponse<Appointment> = try await withVisibleLoading {
                try await api.getUserAppointments(
                    page: page,
                    limit: limit,
                    asCustomer: false
                )
            }
            count = response.count
            appointments.append(contentsOf: response.results)
            page += 1
        } catch {
            // GESTIONARE CORECTĂ A ERORILOR: Convertim eroarea într-un mesaj lizibil pentru utilizator.
            if let localizedError = error as? LocalizedError {
                errorMessage = localizedError.errorDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
}
