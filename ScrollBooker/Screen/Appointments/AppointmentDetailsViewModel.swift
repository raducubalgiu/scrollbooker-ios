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
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Appointments")
    
    private let session: SessionManager
    private let appointmentId: Int
    private let getAppointmentById: GetAppointmentByIdUseCase
    private let cancelAppointment: CancelAppointmentUseCase
    private let createReviewUseCase: CreateReviewUseCase
    private let updateReviewUseCase: UpdateReviewUseCase
    
    var isFinished: Bool {
        viewState.data?.status == .finished
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
        guard viewState.data == nil else { return }
        guard viewState != .loading else { return }
        
        viewState = .loading
        
        do {
            let result = try await withLoading {
                try await getAppointmentById(id: appointmentId)
            }
            viewState = .success(result)
        } catch {
            logger.error("ERROR: on Fetching Appointment: \(error.localizedDescription)")
            viewState = .error("Something went wrong") // Mesaj generic direct în starea ecranului
        }
    }
    
    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        do {
            let result = try await getAppointmentById(id: appointmentId)
            viewState = .success(result)
        } catch {
            logger.error("ERROR: on Refreshing Appointment: \(error.localizedDescription)")
            if viewState.data == nil {
                viewState = .error("Something went wrong")
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
            logger.error("ERROR: on Creating Review: \(error.localizedDescription)")
        }
        
        isSaving = false
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
