//
//  AppointmentsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 06.09.2025.
//

import Foundation

import Foundation

@MainActor // Garantează că toate modificările proprietăților de UI se execută strict pe Thread-ul Principal
final class AppointmentsViewModel: ObservableObject, HasLoadingState {
    
    // MARK: - Single Source of Truth (MVI / State Machine)
    /// Sursa unică de adevăr pentru starea ecranului. SwiftUI randează interfața în funcție de acest enum.
    @Published private(set) var state: UIState<[Appointment]> = .idle
    
    /// Controlează starea vizuală a indicatorului nativ de Pull-to-Refresh din SwiftUI View.
    @Published private(set) var isRefreshing: Bool = false
    
    // Scut Enterprise: Blocăm complet declanșarea request-urilor paralele pe aceleași pagini la scroll rapid
    private var isPaging: Bool = false
    
    // MARK: - HasLoadingState Compliance (Computed Properties)
    /// Getter și Setter inteligent pentru a conecta protocolul tău nativ cu mașina de stări unificată.
    var isLoading: Bool {
        get {
            if case .loading = state { return true }
            return false
        }
        set {
            if newValue {
                state = .loading
            } else {
                if case .loading = state {
                    state = .idle
                }
            }
        }
    }
    
    /// Interceptează momentul în care utilitarul tău `withVisibleLoading` scrie eroarea în `errorMessage`
    /// și o redirectează automat în interiorul cazului structural `.error` din mașina de stări.
    var errorMessage: String? {
        get {
            if case .error(let message) = state { return message }
            return nil
        }
        set {
            if let newValue = newValue {
                state = .error(message: newValue)
            }
        }
    }
    
    // MARK: - Dependencies (Clean Architecture)
    private let getUserAppointmentsUseCase: GetUserAppointmentsUseCase

    // MARK: - Internal Pagination State
    private var allAppointments: [Appointment] = []
    private var page = 1
    private let limit = 10
    private var count = 0
    
    /// Indică dacă mai există pagini de descărcat de pe serverul FastAPI.
    var hasMore: Bool { allAppointments.count < count }
    
    // MARK: - Init
    init(getUserAppointmentsUseCase: GetUserAppointmentsUseCase) {
        self.getUserAppointmentsUseCase = getUserAppointmentsUseCase
    }
    
    // MARK: - Public Actions
    
    /// Se apelează automat la apariția ecranului.
    /// Utilizează framework-ul tău asincron cu timp minim garantat de ContinuousClock.
    func initialLoadIfNeeded() async {
        guard allAppointments.isEmpty else { return }
        
        try? await withVisibleLoading { [unowned self] in
            await self.loadAppointments(isFirstPage: true)
            
            // Dacă logica internă a pus starea pe eroare, forțăm rethrows local
            // pentru ca extensia ta HasLoadingState să activeze corect ramura de eșec
            if case .error(let message) = self.state {
                throw NSError(domain: "Appointments", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
            }
        }
    }
    
    /// Se declanșează la acțiunea nativă de Pull-to-Refresh din listă.
    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        // Resetare contor de pagină, dar păstrăm datele atomice pe ecran
        // până când noul request se întoarce cu succes (UX curat, fără flickering)
        page = 1
        errorMessage = nil
        
        await loadAppointments(isFirstPage: true)
        
        isRefreshing = false
    }
    
    /// Monitorizează poziția scroll-ului și încarcă automat pagina următoare (Infinite Scroll)
    func loadMoreIfNeeded(currentAppointment: Appointment?) async {
        if isLoading || isRefreshing || isPaging { return }
        guard hasMore else { return }
        
        guard let current = currentAppointment,
              current.id == allAppointments.last?.id else { return }
        
        isPaging = true
        // Paginarea de background rulează silențios, fără a re-afișa loader-ul mare de 2 secunde peste datele vechi
        await loadAppointments(isFirstPage: false)
        isPaging = false
    }
    
    // MARK: - Private Core Logic
    /// Executat de Use Case-ul din Domain Layer.
    private func loadAppointments(isFirstPage: Bool) async {
        do {
            // REPARAT: Apelăm instanța direct ca pe o funcție datorită 'callAsFunction' (stil invoke din Kotlin)
            let response = try await getUserAppointmentsUseCase(page: page, limit: limit)
            
            if isFirstPage {
                // Înlocuire atomică la succes: eliminăm complet flash-urile de ecran gol
                allAppointments = response.results
            } else {
                // Filtrare defensivă O(1) bazată pe Set pentru a elimina complet
                // avertismentele de ID-uri duplicate din ForEach în SwiftUI la scroll rapid
                let existingIds = Set(allAppointments.map { $0.id })
                let uniqueNewResults = response.results.filter { !existingIds.contains($0.id) }
                
                allAppointments.append(contentsOf: uniqueNewResults)
            }
            
            count = response.count
            page += 1
            
            // Actualizăm starea unică de succes
            state = .success(allAppointments)
            errorMessage = nil
            
        } catch {
            let friendlyMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            
            if isFirstPage {
                state = .error(message: friendlyMessage)
                errorMessage = friendlyMessage
            } else {
                // Paginarea secundară menține datele vechi pe ecran în caz de eșec tranzitoriu de net
                state = .success(allAppointments)
            }
        }
    }
}
