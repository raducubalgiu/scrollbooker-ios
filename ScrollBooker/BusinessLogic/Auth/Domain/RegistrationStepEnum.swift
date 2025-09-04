//
//  RegistrationStepEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 03.09.2025.
//

import Foundation

enum RegistrationStepEnum: String, Codable, CaseIterable {
    case collectUserEmailValidation = "collect_user_email_validation"
    case collectUserUsername = "collect_user_username"
    case collectClientBirthdate = "collect_client_birthdate"
    case collectClientGender = "collect_client_gender"
    case collectClientLocation = "collect_client_location_permission"
    case collectBusiness = "collect_business"
    case collectBusinessServices = "collect_business_services"
    case collectBusinessSchedules = "collect_business_schedules"
    case collectBusinessHasEmployees = "collect_business_has_employees"
    case collectBusinessValidation = "collect_business_validation"

    static func fromKey(_ key: String?) -> RegistrationStepEnum? {
        guard let key = key else { return nil }
        return RegistrationStepEnum.allCases.first { $0.rawValue == key }
    }
}
