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
    
    var appointment: Appointment? {
        if case .success(let appointment) = self { return appointment }
        return nil
    }
}

@Observable
@MainActor
final class AppointmentDetailsViewModel: HasLoadingState {
    private(set) var viewState: AppointmentDetailsState = .idle
    
    var isRefreshing: Bool = false
    private(set) var operationErrorMessage: String? = nil
    private(set) var isPerformingAction: Bool = false
    
    private let session: SessionManager
    private let appointmentId: Int
    private let getAppointmentById: GetAppointmentByIdUseCase
    private let cancelAppointment: CancelAppointmentUseCase
    private let createReviewUseCase: CreateReviewUseCase
    private let updateReviewUseCase: UpdateReviewUseCase
    
    var isFinished: Bool {
        viewState.appointment?.status == .finished
    }
    
    var isLoading: Bool {
        get { if case .loading = viewState { return true }; return isPerformingAction }
        set { isPerformingAction = newValue }
    }
    
    var errorMessage: String? {
        get {
            if case .error(let msg) = viewState { return msg }
            return operationErrorMessage
        }
        set { operationErrorMessage = newValue }
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
        guard viewState.appointment == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        operationErrorMessage = nil
        
        do {
            let result = try await withVisibleLoading {
                try await getAppointmentById(id: appointmentId)
            }
            viewState = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            viewState = .error(message)
        }
    }
    
    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        operationErrorMessage = nil
        
        do {
            let result = try await getAppointmentById(id: appointmentId)
            viewState = .success(result)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            if viewState.appointment == nil {
                viewState = .error(message)
            } else {
                operationErrorMessage = message
            }
        }
        isRefreshing = false
    }
    
    func cancelCurrentAppointment(reason: String) async {
        operationErrorMessage = nil
        isPerformingAction = true
        
        do {
            guard let userId = session.userInfo?.id else {
                operationErrorMessage = "User session not found"
                isPerformingAction = false
                return
            }
            
            let updatedAppointment = try await withVisibleLoading {
                try await cancelAppointment(
                    id: appointmentId,
                    canceledReason: reason,
                    canceledByUserId: userId
                )
            }
            
            viewState = .success(updatedAppointment)
            isPerformingAction = false
            
        } catch {
            operationErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            isPerformingAction = false
        }
    }
    
    func createReview(review: String, rating: Int, userId: Int, productId: Int) async {
        guard let currentAppointment = viewState.appointment else { return }
        operationErrorMessage = nil
        isPerformingAction = true
        
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
            
            isPerformingAction = false
            updateStateWithNewReview(newReview, from: currentAppointment)
            
        } catch {
            operationErrorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            isPerformingAction = false
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
        
        viewState = .success(updatedAppointment)
    }
}
