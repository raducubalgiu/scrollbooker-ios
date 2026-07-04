//
//  AuthRoute.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 04.09.2025.
//

import SwiftUI

enum AuthRoute: Hashable {
    case login
    case registerClient
    case registerBusiness
    
    case collectEmailValidation
    case collectUserUsername
    case collectUserPhoneNumber
    
    case collectClientBirthdate
    case collectClientGender
    case collectClientLocationPermission
    
    case collectBusiness
    case collectBusinessDetails
    case collectBusinessLocation
    case collectBusinessGallery
    
    case collectBusinessServices
    case collectBusinessSchedules
    case collectBusinessHasEmployees
    case collectBusinessValidation
    
    case collectBusinessCurrencies
}

extension AuthRoute {
    init(step: RegistrationStepEnum) {
        switch step {
        case .collectUserEmailValidation:
            self = .collectEmailValidation
            
        case .collectUserUsername:
            self = .collectUserUsername
            
        case .collectUserPhoneHumber:
            self = .collectUserPhoneNumber
            
        case .collectClientBirthdate:
            self = .collectClientBirthdate
            
        case .collectClientGender:
            self = .collectClientGender
            
        case .collectClientLocationPermission:
            self = .collectClientLocationPermission
            
        case .collectBusiness:
            self = .collectBusiness
            
        case .collectBusinessServices:
            self = .collectBusinessServices
            
        case .collectBusinessSchedules:
            self = .collectBusinessSchedules
            
        case .collectBusinessHasEmployees:
            self = .collectBusinessHasEmployees
            
        case .collectBusinessValidation:
            self = .collectBusinessValidation
            
        case .collectBusinessCurrencies:
            self = .collectBusinessCurrencies
        }
    }
}
