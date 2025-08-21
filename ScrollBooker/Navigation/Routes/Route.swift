//
//  Route.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

enum Route: Hashable {
    case feed
    case inbox
    case search
    
    case appointments
    case appointmentDetails(id: Int)
    case appointmentCancel(id: Int)
    
    case myProfile
    
    case feedSearch
}
