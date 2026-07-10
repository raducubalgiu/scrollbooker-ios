//
//  AppointmentDetailsViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 09.07.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class AppointmentDetailsViewModel: HasLoadingState {
    var uiState = UiState(data: Appointment?.none)
    
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
        get { uiState.isLoading }
        set { uiState.isLoading = newValue }
    }
    
    var errorMessage: String? {
        get { uiState.errorMessage }
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
        uiState.errorMessage = nil
        
        do {
            let result = try await withVisibleLoading {
                try await getAppointmentById(id: appointmentId)
            }
            uiState.data = result
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            uiState.errorMessage = message
        }
    }
    
    func refresh() async {
        guard !uiState.isRefreshing else { return }
        uiState.isRefreshing = true
        uiState.errorMessage = nil
        
        do {
            let result = try await getAppointmentById(id: appointmentId)
            uiState.data = result
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            uiState.errorMessage = message
        }
        uiState.isRefreshing = false
    }
    
    func cancelCurrentAppointment(reason: String) async {
        uiState.errorMessage = nil
        
        do {
            guard let userId = session.userInfo?.id else {
                uiState.errorMessage = "User session not found"
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
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            uiState.errorMessage = message
        }
    }
    
    func createReview(
        review: String,
        rating: Int,
        userId: Int,
        productId: Int
    ) async {
        guard let currentAppointment = uiState.data else { return }
        
        uiState.errorMessage = nil
        
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
            
            updateStateWithNewReview(newReview, from: currentAppointment)
            
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            uiState.errorMessage = message
        }
    }
    
    func updateReview(reviewId: Int, rating: Int, review: String) async {
//        guard let currentAppointment = uiState.data else { return }
//        uiState.errorMessage = nil
//        
//        let request = ReviewUpdateRequest(rating: rating, review: review)
//        
//        do {
//            let updatedReview = try await withVisibleLoading {
//                try await updateReviewUseCase(id: reviewId, request: request)
//            }
//            
//            updateStateWithNewReview(updatedReview, from: currentAppointment)
//            
//        } catch {
//            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
//            uiState.errorMessage = message
//        }
    }
    
    private func updateStateWithNewReview(_ review: Review, from current: Appointment) {
        let appointmentReview = AppointmentWrittenReview(
            id: review.id,
            review: review.review,
            rating: review.rating
        )
        
        let updatedAppointment = Appointment(
            id: current.id,
            startDate: current.startDate,
            endDate: current.endDate,
            channel: current.channel,
            status: current.status,
            message: current.message,
            isCustomer: current.isCustomer,
            products: current.products,
            user: current.user,
            customer: current.customer,
            business: current.business,
            totalPrice: current.totalPrice,
            totalPriceWithDiscount: current.totalPriceWithDiscount,
            totalDiscount: current.totalDiscount,
            totalDuration: current.totalDuration,
            paymentCurrency: current.paymentCurrency,
            hasWrittenReview: true,
            hasVideoReview: current.hasVideoReview,
            writtenReview: appointmentReview
        )
        
        self.uiState.data = updatedAppointment
    }
}
