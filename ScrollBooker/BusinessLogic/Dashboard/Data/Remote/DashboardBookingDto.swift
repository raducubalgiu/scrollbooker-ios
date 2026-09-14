//
//  DashboardBookingDto.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

struct DashboardBookingDto: Decodable {
    let bookingsNo: Int
    let finishedBookingsNo: Int
    let cancelledBookingsNo: Int

    @LossyDecimal
    var revenue: Decimal

    @LossyDecimal
    var revenueWithoutCancellation: Decimal

    @LossyDecimal
    var revenueFromVideo: Decimal

    @LossyDecimal
    var revenueScrollBooker: Decimal

    let channels: [DashboardBookingChannelDto]
    let sources: [DashboardBookingSourceDto]

    enum CodingKeys: String, CodingKey {
        case bookingsNo = "bookings_no"
        case finishedBookingsNo = "finished_bookings_no"
        case cancelledBookingsNo = "cancelled_bookings_no"
        case revenue
        case revenueWithoutCancellation = "revenue_without_cancelled"
        case revenueFromVideo = "revenue_from_video"
        case revenueScrollBooker = "revenue_scroll_booker"
        case channels
        case sources
    }
}

struct DashboardBookingChannelDto: Decodable {
    let channel: String
    let bookingsNo: Int

    @LossyDecimal
    var revenue: Decimal

    let percentage: Float

    enum CodingKeys: String, CodingKey {
        case channel
        case bookingsNo = "bookings_no"
        case revenue
        case percentage
    }
}

struct DashboardBookingSourceDto: Decodable {
    let source: String
    let bookingsNo: Int

    @LossyDecimal
    var revenue: Decimal

    let percentage: Float

    enum CodingKeys: String, CodingKey {
        case source
        case bookingsNo = "bookings_no"
        case revenue
        case percentage
    }
}
