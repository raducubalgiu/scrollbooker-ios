//
//  AppointmentDetailsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//
import Observation
import Foundation
import OSLog

@Observable
@MainActor
final class AppointmentDetailsViewModel {
    private(set) var viewState: FeatureState<Appointment> = .idle
    
    var isSaving: Bool = false
    var isRefreshing: Bool = false
    var errorMessage: String?
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Appointments")
    
    private let session: SessionManager
    private let appointmentId: Int
    private let getAppointmentById: GetAppointmentByIdUseCase
    private let cancelAppointment: CancelAppointmentUseCase
    private let createReviewUseCase: CreateReviewUseCase
    private let updateReviewUseCase: UpdateReviewUseCase
    private let deleteReviewUseCase: DeleteReviewUseCase

    var isFinished: Bool {
        viewState.data?.status == .finished
    }

    init(
        session: SessionManager,
        appointmentId: Int,
        getAppointmentById: GetAppointmentByIdUseCase,
        cancelAppointment: CancelAppointmentUseCase,
        createReviewUseCase: CreateReviewUseCase,
        updateReviewUseCase: UpdateReviewUseCase,
        deleteReviewUseCase: DeleteReviewUseCase
    ) {
        self.session = session
        self.appointmentId = appointmentId
        self.getAppointmentById = getAppointmentById
        self.cancelAppointment = cancelAppointment
        self.createReviewUseCase = createReviewUseCase
        self.updateReviewUseCase = updateReviewUseCase
        self.deleteReviewUseCase = deleteReviewUseCase
    }
    
    func loadAppointment() async {
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        
        do {
            let result = try await withLoading {
                try await getAppointmentById(id: appointmentId)
            }
            viewState = .success(result)
        } catch {
            viewState = .error(logger.userMessage(for: error, context: "Fetching Appointment"))
        }
    }
    
    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        do {
            let result = try await getAppointmentById(id: appointmentId)
            viewState = .success(result)
        } catch {
            let message = logger.userMessage(for: error, context: "Refreshing Appointment")
            if viewState.data == nil {
                viewState = .error(message)
            }
        }
        isRefreshing = false
    }
    
    func cancelCurrentAppointment(reason: String) async {
        guard let currentAppointment = viewState.data else { return }
        
        isSaving = true
        
        guard let userId = session.userInfo?.id else {
            logger.error("ERROR: User session / ID not found")
            isSaving = false
            // Aici în UI poți declanșa o alertă generică locală dacă dorești
            return
        }
        
        do {
            let updatedAppointment = try await withLoading {
                try await cancelAppointment(
                    id: appointmentId,
                    canceledReason: reason,
                    canceledByUserId: userId
                )
            }
            
            if updatedAppointment.id == currentAppointment.id {
                viewState = .success(updatedAppointment)
            }
            
        } catch {
            logger.error("ERROR: on Cancelling Appointment: \(error.localizedDescription)")
        }
        
        isSaving = false
    }
    
    func createReview(review: String, rating: Int, userId: Int, productId: Int) async {
        guard let currentAppointment = viewState.data else { return }
        isSaving = true
        errorMessage = nil

        let request = ReviewCreateRequest(
            review: review,
            rating: rating,
            user_id: userId,
            product_id: productId,
            parent_id: nil
        )

        do {
            let newReview = try await withLoading {
                try await createReviewUseCase(id: appointmentId, request: request)
            }
            updateStateWithNewReview(newReview, from: currentAppointment)
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Creating Review")
        }

        isSaving = false
    }

    func updateReview(reviewId: Int, review: String, rating: Int) async {
        guard let currentAppointment = viewState.data else { return }
        isSaving = true
        errorMessage = nil

        let request = ReviewUpdateRequest(review: review, rating: rating)

        do {
            let updatedReview = try await withLoading {
                try await updateReviewUseCase(id: reviewId, request: request)
            }
            updateStateWithNewReview(updatedReview, from: currentAppointment)
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Updating Review")
        }

        isSaving = false
    }

    func deleteReview(reviewId: Int) async -> Bool {
        guard let currentAppointment = viewState.data else { return false }
        isSaving = true
        errorMessage = nil

        do {
            _ = try await withLoading {
                try await deleteReviewUseCase(id: reviewId)
            }

            viewState = .success(
                currentAppointment.copy(hasWrittenReview: false, writtenReview: .some(nil))
            )
            isSaving = false
            return true
        } catch {
            errorMessage = logger.userMessage(for: error, context: "Deleting Review")
            isSaving = false
            return false
        }
    }

    private func updateStateWithNewReview(_ review: ReviewMutationResult, from current: Appointment) {
        let appointmentReview = AppointmentWrittenReview(
            id: review.id,
            review: review.review,
            rating: review.rating,
            isEditable: true,
            createdAt: review.createdAt
        )

        let updatedAppointment = current.copy(
            hasWrittenReview: true,
            writtenReview: appointmentReview
        )

        viewState = .success(updatedAppointment)
    }
}
