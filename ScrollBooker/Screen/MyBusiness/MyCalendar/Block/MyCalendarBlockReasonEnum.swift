//
//  MyCalendarBlockReasonEnum.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.09.2026.
//

import Foundation

enum MyCalendarBlockReasonEnum: CaseIterable, Hashable {
    case vacation
    case medicalLeave
    case doctorAppointment
    case legalDayOff
    case doNotWantToSay
    case other

    var label: String {
        switch self {
            case .vacation: String(localized: "reason_vacation")
            case .medicalLeave: String(localized: "reason_medical_leave")
            case .doctorAppointment: String(localized: "reason_doctor_appointment")
            case .legalDayOff: String(localized: "reason_legal_day_off")
            case .doNotWantToSay: String(localized: "iDoNotWantToSay")
            case .other: String(localized: "otherReason")
        }
    }
}
