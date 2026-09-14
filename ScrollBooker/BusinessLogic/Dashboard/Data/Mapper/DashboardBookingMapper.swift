//
//  DashboardBookingMapper.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

import Foundation

extension DashboardBooking {
    init(dto: DashboardBookingDto) {
        self.bookingsNo = dto.bookingsNo
        self.finishedBookingsNo = dto.finishedBookingsNo
        self.cancelledBookingsNo = dto.cancelledBookingsNo
        self.revenue = dto.revenue
        self.revenueWithoutCancellation = dto.revenueWithoutCancellation
        self.revenueFromVideo = dto.revenueFromVideo
        self.revenueScrollBooker = dto.revenueScrollBooker
        self.channels = dto.channels.map { DashboardBookingChannel(dto: $0) }
        self.sources = dto.sources.map { DashboardBookingSource(dto: $0) }
    }
}

extension DashboardBookingChannel {
    init(dto: DashboardBookingChannelDto) {
        self.channel = AppointmentChannelEnum.fromKey(dto.channel)
        self.bookingsNo = dto.bookingsNo
        self.revenue = dto.revenue
        self.percentage = dto.percentage
    }
}

extension DashboardBookingSource {
    init(dto: DashboardBookingSourceDto) {
        self.source = BookingSourceEnum.fromKey(dto.source)
        self.bookingsNo = dto.bookingsNo
        self.revenue = dto.revenue
        self.percentage = dto.percentage
    }
}
