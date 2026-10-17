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
    var appointmentId: Int? = nil
    var instantBooking: Bool = true
}

struct SocialNavigationParams: Hashable, Identifiable {
    let id = UUID()

    let userId: Int
    let username: String
    let initialTab: SocialTab
    let isBusinessOrEmployee: Bool
    let followersCount: Int
    let followingsCount: Int
    let businessId: Int?
    let employeeId: Int?
}

struct ProfileNavigationParams: Hashable, Identifiable {
    let id = UUID()

    let userId: Int
    let username: String
}

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
    case employmentRequestRespond(id: Int)
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
    case reviewVideoDetail
    
    case editProfile
    case editFullName
    case editUsername
    case editBio
    case editGender
    case editBirthdate
    case editProfession
    case editAvatarCrop
    case editPublicPhone
    case publicPhoneVerification
    
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
    case account
    case accountInfo
    case phoneVerification
    case password
    case deactivateDeleteAccount
    case deleteAccount
    case display
    case reportProblem
    
    // Camera — CameraPreview/CreatePost/CreatePostPreview/CreatePostCover are local steps
    // owned by CameraFlowContainer, not separate global routes (see Navigation+Global.swift).
    case camera(CameraParams)
    
    // Booking
    case bookingServices(BookingNavigationParams)
    case bookingSpecialists
    case bookingDateTime
    case bookingConfirmation
}
