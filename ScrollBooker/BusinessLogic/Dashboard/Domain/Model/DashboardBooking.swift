//
//  DashboardBooking.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

struct DashboardBooking: Equatable, Hashable, Sendable {
    let bookingsNo: Int
    let finishedBookingsNo: Int
    let cancelledBookingsNo: Int
    let revenue: Decimal
    let revenueWithoutCancellation: Decimal
    let revenueFromVideo: Decimal
    let revenueScrollBooker: Decimal
    let channels: [DashboardBookingChannel]
    let sources: [DashboardBookingSource]
}

struct DashboardBookingChannel: Equatable, Hashable, Sendable {
    let channel: AppointmentChannelEnum?
    let bookingsNo: Int
    let revenue: Decimal
    let percentage: Float
}

struct DashboardBookingSource: Equatable, Hashable, Sendable {
    let source: BookingSourceEnum?
    let bookingsNo: Int
    let revenue: Decimal
    let percentage: Float
}
