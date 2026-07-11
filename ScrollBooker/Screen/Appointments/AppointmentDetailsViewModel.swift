//
//  AppointmentDetailsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation
import Observation

enum AppointmentDetailsState: Equatable {
    case idle
    case loading
    case success(Appointment)
    case error(String)
}

@Observable
@MainActor
final class AppointmentDetailsViewModel: HasLoadingState {
    var uiState = UiState(data: Appointment?.none)
    
    private(set) var viewState: AppointmentDetailsState = .idle
    
    private let session: SessionManager
    private let appointmentId: Int
    private let getAppointmentById: GetAppointmentByIdUseCase
    private let cancelAppointment: CancelAppointmentUseCase
    private let createReviewUseCase: CreateReviewUseCase
    private let updateReviewUseCase: UpdateReviewUseCase
    
    var isFinished: Bool {
        uiState.data?.status == .finished
    }
    
    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return uiState.isLoading }
        set { uiState.isLoading = newValue }
    }
    
    var errorMessage: String? {
        get { if case .error(let msg) = viewState { return msg }; return uiState.errorMessage }
        set { uiState.errorMessage = newValue }
    }
    
    init(
        session: SessionManager,
        appointmentId: Int,
        getAppointmentById: GetAppointmentByIdUseCase,
        cancelAppointment: CancelAppointmentUseCase,
        createReviewUseCase: CreateReviewUseCase,
        updateReviewUseCase: UpdateReviewUseCase
    ) {
        self.session = session
        self.appointmentId = appointmentId
        self.getAppointmentById = getAppointmentById
        self.cancelAppointment = cancelAppointment
        self.createReviewUseCase = createReviewUseCase
        self.updateReviewUseCase = updateReviewUseCase
    }
    
    func loadAppointment() async {
        guard uiState.data == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        uiState.errorMessage = nil
        
        do {
            let result = try await withVisibleLoading {
                try await getAppointmentById(id: appointmentId)
            }
            uiState.data = result
            viewState = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            viewState = .error(message)
        }
    }
    
    func refresh() async {
        guard !uiState.isRefreshing else { return }
        uiState.isRefreshing = true
        uiState.errorMessage = nil
        
        do {
            let result = try await getAppointmentById(id: appointmentId)
            uiState.data = result
            viewState = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            if uiState.data == nil {
                viewState = .error(message)
            } else {
                uiState.errorMessage = message
            }
        }
        uiState.isRefreshing = false
    }
    
    func cancelCurrentAppointment(reason: String) async {
        uiState.errorMessage = nil
        uiState.isLoading = true
        
        do {
            guard let userId = session.userInfo?.id else {
                uiState.errorMessage = "User session not found"
                uiState.isLoading = false
                return
            }
            
            let updatedAppointment = try await withVisibleLoading {
                try await cancelAppointment(
                    id: appointmentId,
                    canceledReason: reason,
                    canceledByUserId: userId
                )
            }
            
            uiState.data = updatedAppointment
            viewState = .success(updatedAppointment)
            uiState.isLoading = false
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            uiState.errorMessage = message
            uiState.isLoading = false
        }
    }
    
    func createReview(review: String, rating: Int, userId: Int, productId: Int) async {
        guard let currentAppointment = uiState.data else { return }
        uiState.errorMessage = nil
        uiState.isLoading = true
        
        let request = ReviewCreateRequest(
            review: review,
            rating: rating,
            user_id: userId,
            product_id: productId,
            parent_id: nil
        )
        
        do {
            let newReview = try await withVisibleLoading {
                try await createReviewUseCase(id: appointmentId, request: request)
            }
            
            uiState.isLoading = false
            
            updateStateWithNewReview(newReview, from: currentAppointment)
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            uiState.errorMessage = message
            uiState.isLoading = false
        }
    }

    private func updateStateWithNewReview(_ review: Review, from current: Appointment) {
        let appointmentReview = AppointmentWrittenReview(
            id: review.id,
            review: review.review,
            rating: review.rating
        )
        
        let updatedAppointment = current.copy(
            hasWrittenReview: true,
            writtenReview: appointmentReview
        )
        
        self.uiState.data = updatedAppointment
        self.viewState = .success(updatedAppointment)
    }
}
