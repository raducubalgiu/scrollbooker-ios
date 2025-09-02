//
//  Route.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

enum Route: Hashable {
    // Feed
    case feed
    case feedSearch
    case feedSearchResults
    
    // Inbox
    case inbox
    case employmentRequestRespond
    case employmentRequestRespondConsent
    
    // Search
    case search
    case businessProfile(id: Int)
    
    // Appointments
    case appointments
    case appointmentDetails(id: Int)
    case appointmentCancel(id: Int)
    
    // Profile
    case myProfile
    case myProfilePostDetail
    case userProfile
    case userProducts
    
    case editProfile
    case editFullName
    case editUsername
    case editBio
    case editGender
    case editProfession
    
    case userSocial
    
    case calendar
    case appointmentConfirmation
    case camera
    
    // My Business
    case myBusiness
    
    case myEmployees
    case myEmployeesDismissal
    
    case myEmploymentRequests
    case employmentSelectEmployee
    case employmentAssignJob
    case employmentAcceptTerms
    
    case myCalendar
    case myServices
    case mySchedules
    case myCurrencies
    
    case myProducts
    case addProduct
    case editProducts
    
    // Settings
    case mySettings
    case account
    case privacy
    case security
    case notificationSettings
    case display
    case reportProblem
    case support
    case termsAndConditions
}
