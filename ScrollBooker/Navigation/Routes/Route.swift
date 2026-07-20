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
    
    case userSocial(SocialNavigationParams)
    
    case calendar
    case appointmentConfirmation
    case camera
    
    // My Business
    case myBusiness
    case myBusinessDetails
    case myEmployees
    
    case employmentSelectEmployee
    case employmentAssignJob
    case employmentAcceptTerms
    
    case myCalendar
    case myServices
    case mySchedules
    
    case myProducts
    case addProduct
    case editProducts
    
    // Settings
    case mySettings
    case display
    case reportProblem
    
    // Booking
    case bookingServices(BookingNavigationParams)
    case bookingSpecialists
    case bookingDateTime
    case bookingConfirmation
}
