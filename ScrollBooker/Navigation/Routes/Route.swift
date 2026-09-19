//
//  Route.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import Foundation

struct BookingNavigationParams: Hashable, Identifiable {
    let id = UUID()
    
    let businessId: Int
    let userId: Int
    let businessOwnerId: Int
    let source: BookingSourceEnum
    let selectedProductId: Int?
}

struct SocialNavigationParams: Hashable, Identifiable {
    let id = UUID()
    
    let userId: Int
    let username: String
    let initialTab: SocialTab
    let isBusinessOrEmployee: Bool
    let followersCount: Int
    let followingsCount: Int
}

struct ProfileNavigationParams: Hashable, Identifiable {
    let id = UUID()

    let userId: Int
    let username: String
}

// appointmentId/businessOrEmployeeId are only set when Camera is entered from an
// appointment's "leave a video review" CTA (not built yet) — nil for a normal post.
struct CameraParams: Hashable {
    var appointmentId: Int? = nil
    var businessOrEmployeeId: Int? = nil
}


enum Route: Hashable {
    // Feed
    case feed
    case feedSearch
    
    // Inbox
    case inbox
    case employmentRequestRespond
    case employmentRequestRespondConsent
    
    // Search
    case search
    case businessProfile(username: String)
    
    // Appointments
    case appointments
    case appointmentDetails(id: Int)
    
    // Profile
    case myProfile
    case userProfile(ProfileNavigationParams)
    case profilePostDetail
    
    case editProfile
    case editFullName
    case editUsername
    case editBio
    case editGender
    case editBirthdate
    case editProfession
    case editAvatarCrop
    
    case userSocial(SocialNavigationParams)
    
    // My Business
    case myBusiness
    case myBusinessDetails
    case unapprovedBusinesses
    
    case myEmployees
    case employmentSelectEmployee
    case employmentAssignJob
    case employmentAcceptTerms
    
    case myCalendar
    case myServices
    case mySchedules
    case myDashboard
    
    case myProducts
    case addProduct
    case editProduct(productId: Int)
    
    // Settings
    case mySettings
    case display
    case reportProblem
    
    // Camera
    case camera(CameraParams)
    case cameraPreview
    case createPost
    case createPostPreview
    case createPostCover
    
    // Booking
    case bookingServices(BookingNavigationParams)
    case bookingSpecialists
    case bookingDateTime
    case bookingConfirmation
}
