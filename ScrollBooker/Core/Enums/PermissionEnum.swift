//
//  PermissionEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.09.2026.
//

import Foundation

enum PermissionEnum: String, CaseIterable, Equatable, Hashable, Sendable, Codable {
    case nomenclaturesView = "NOMENCLATURES_VIEW"
    case adminButtonView = "ADMIN_BUTTON_VIEW"
    case editUserProfession = "EDIT_USER_PROFESSION"
    case bookButtonView = "BOOK_BUTTON_VIEW"
    case postCreate = "POST_CREATE"

    case productEdit = "PRODUCT_EDIT"
    case productDelete = "PRODUCT_DELETE"

    case genderEdit = "GENDER_EDIT"
    case birthdateEdit = "BIRTHDATE_EDIT"

    case filterAppointmentsView = "FILTER_APPOINTMENTS_VIEW"

    // My Business
    case myBusinessRoutesView = "MY_BUSINESS_ROUTES_VIEW"
    case myDashboardView = "MY_DASHBOARD_VIEW"

    case mySubscriptionView = "MY_SUBSCRIPTION_VIEW"

    case myBusinessLocationView = "MY_BUSINESS_LOCATION_VIEW"
    case mySchedulesView = "MY_SCHEDULES_VIEW"

    case myProductsView = "MY_PRODUCTS_VIEW"
    case myServicesView = "MY_SERVICES_VIEW"

    case myCalendarView = "MY_CALENDAR_VIEW"
    case myCurrenciesView = "MY_CURRENCIES_VIEW"

    case myEmployeesView = "MY_EMPLOYEES_VIEW"
    case myEmploymentRequestsView = "MY_EMPLOYMENT_REQUESTS_VIEW"

    case noProtection = "NO_PROTECTION"

    static func fromKey(_ key: String) -> PermissionEnum? {
        PermissionEnum(rawValue: key)
    }

    static func fromKeys(_ keys: [String]) -> [PermissionEnum] {
        keys.compactMap { PermissionEnum(rawValue: $0) }
    }
}

extension Array where Element == PermissionEnum {
    func has(_ permission: PermissionEnum) -> Bool {
        contains(permission)
    }
}
