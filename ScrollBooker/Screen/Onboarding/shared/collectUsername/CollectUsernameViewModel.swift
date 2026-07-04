//
//  CollectUserUsernameViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.09.2025.
//

import Foundation
import Observation

// MARK: - Safe Task Utility
/// Un container non-isolated folosit pentru a stoca și anula Task-uri în siguranță
/// din deinit sub regimul strict de concurență din Swift 6.
private final class TaskHolder: @unchecked Sendable { // Am adăugat @unchecked aici
    private let lockedTask = NSRecursiveLock()
    private var _task: Task<Void, Never>?
    
    var task: Task<Void, Never>? {
        get {
            lockedTask.lock()
            defer { lockedTask.unlock() }
            return _task
        }
        set {
            lockedTask.lock()
            let oldTask = _task
            _task = newValue
            lockedTask.unlock()
            
            // Dacă se setează un task nou sau nil, îl anulăm imediat pe cel vechi
            oldTask?.cancel()
        }
    }
    
    deinit {
        _task?.cancel()
    }
}

// MARK: - View Model Implementation
@Observable
@MainActor // Garantează că toate modificările proprietăților de UI se fac strict pe Thread-ul Principal
final class CollectUsernameViewModel {
    
    // MARK: - Dependencies
    private let api: OnboardingAPI
    private let session: SessionManager
    
    // MARK: - UI State
    var username: String = ""
    var isLoading: Bool = false
    var isAvailable: Bool = false
    var suggestions: [String] = []
    var errorMessage: String?
    
    // Container-ul imutabil pentru gestionarea sigură a task-urilor asincrone de căutare
    private let searchTaskHolder = TaskHolder()
    
    // MARK: - Init
    init(api: OnboardingAPI, session: SessionManager) {
        self.api = api
        self.session = session
    }
    
    // Observație: Nu mai avem nevoie de un bloc `deinit` manual aici.
    // În momentul în care ViewModel-ul moare, `searchTaskHolder` se distruge nativ
    // și își execută propriul deinit non-isolated, anulând request-urile de rețea.
    
    // MARK: - Intentions / Actions
    
    /// Se apelează la fiecare modificare a textului din TextField.
    /// Implementează un mecanism nativ de Debounce (300 ms) pentru a proteja backend-ul.
    func onUsernameChanged(_ newValue: String) async {
        username = newValue
        
        guard newValue.count >= 3 else {
            searchTaskHolder.task = nil // Anulează automat orice operațiune precedentă
            isAvailable = false
            suggestions = []
            errorMessage = nil
            isLoading = false
            return
        }
        
        // Anulăm task-ul precedent înainte de a programa noua fereastră de debounce
        searchTaskHolder.task = nil
        
        // Cream un nou Task imersat în contextul @MainActor al clasei
        searchTaskHolder.task = Task {
            // Fereastra de debounce de 300 milisecunde
            try? await Task.sleep(for: .milliseconds(300))
            
            // Dacă utilizatorul a continuat să tasteze în aceste 300ms, ieșim imediat
            if Task.isCancelled { return }
            
            await performSearch(for: newValue)
        }
    }
    
    /// Execută interogarea efectivă a serverului pentru verificarea disponibilității.
    private func performSearch(for value: String) async {
        // SOLUȚIE ENTERPRISE: Am eliminat verificarea manuală de token.
        // Interceptorul rețelei se ocupă transparent de sesiune.
        let start = ContinuousClock.now
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Apel asincron curat către API, fără propagare de token string
            let response = try await api.searchUsername(username: value)
            
            // Mecanism anti-glitch: verificăm dacă răspunsul sosit asincron mai corespunde
            // cu ceea ce se află scris acum pe ecran și dacă task-ul nu a fost anulat
            guard value == username else { return }
            if Task.isCancelled { return }
            
            isAvailable = response.available
            suggestions = response.suggestions
            errorMessage = nil
        } catch {
            guard value == username else { return }
            if Task.isCancelled { return }
            
            // Mapare robustă a erorilor din sistem
            if let localizedError = error as? LocalizedError {
                errorMessage = localizedError.errorDescription
            } else {
                errorMessage = error.localizedDescription
            }
            isAvailable = false
            suggestions = []
        }
        
        // Evităm pâlpâirea interfeței grafice dacă serverul răspunde instant (sub 300ms)
        let elapsed = start.duration(to: .now)
        if elapsed < .milliseconds(300) {
            try? await Task.sleep(for: .milliseconds(300) - elapsed)
        }
    }
    
    /// Trimite username-ul validat definitiv către fluxul de înregistrare al serverului.
    func collectUsername() async {
        let start = ContinuousClock.now
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Apel purificat de parametri de sesiune redundanți
            let response = try await api.collectUsername(username: username)
            print("Successfully collected username:", response)
            errorMessage = nil
            
            // Sfat Enterprise: Aici vei actualiza starea sesiunii dacă este necesar
            // await session.updateAuthState(response)
        } catch {
            if let localizedError = error as? LocalizedError {
                errorMessage = localizedError.errorDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }
        
        let elapsed = start.duration(to: .now)
        if elapsed < .milliseconds(300) {
            try? await Task.sleep(for: .milliseconds(300) - elapsed)
        }
    }
}

