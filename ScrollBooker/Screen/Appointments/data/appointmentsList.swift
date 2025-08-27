//
//  appointmentsList.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.08.2025.
//

import Foundation

public let appointmentsList: [Appointment] = [
    Appointment(
        id: 1,
        startDate: Date(),
        endDate: Date().addingTimeInterval(3600),
        channel: "scroll_booker",
        status: "confirmat",
        message: "",
        product: AppointmentProduct(
            id: 1,
            name: "Tuns Special",
            price: 50.0,
            priceWithDiscount: 50.0,
            discount: 0.0,
            currency: "RON",
            exchangeRate: 1.0
        ),
        user: AppointmentUser(
            id: 1,
            avatar: "https://media.scrollbooker.ro/avatar-male-9.jpeg",
            fullName: "Raducu Balgiu",
            username: "@radu_balgiu",
            profession: "Creator"
        ),
        isCustomer: true,
        business: AppointmentBusiness(
            address: "Bulevardul Iuliu Maniu 67, Bucuresti, 077042, Romania",
            coordinates: BusinessCoordinates(
                lat: 26.020075,
                lng: 44.433552
            )
        )
    )
]
