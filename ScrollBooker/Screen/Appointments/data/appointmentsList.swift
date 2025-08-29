//
//  appointmentsList.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.08.2025.
//

import Foundation

let appointmentsList: [Appointment] = [
    Appointment(
        id: 1,
        startDate: Date(),
        endDate: Date().addingTimeInterval(3600),
        channel: "scroll_booker",
        status: AppointmentStatus(raw: "confirmed"),
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
            fullName: "Radu Ion",
            username: "@radu_ion",
            profession: "Stylist"
        ),
        isCustomer: true,
        business: AppointmentBusiness(
            address: "Bulevardul Iuliu Maniu 67, Bucuresti, 077042, Romania",
            coordinates: BusinessCoordinates(
                lat: 44.433552,
                lng: 26.020075
            )
        )
    ),
    Appointment(
        id: 2,
        startDate: Date(),
        endDate: Date().addingTimeInterval(3600),
        channel: "scroll_booker",
        status: AppointmentStatus(raw: "finished"),
        message: "",
        product: AppointmentProduct(
            id: 2,
            name: "Curs de dans bachata",
            price: 100.0,
            priceWithDiscount: 50.0,
            discount: 0.0,
            currency: "RON",
            exchangeRate: 1.0
        ),
        user: AppointmentUser(
            id: 2,
            avatar: "https://media.scrollbooker.ro/avatar-male-9.jpeg",
            fullName: "Salsa Factory",
            username: "@salsa_factory",
            profession: "Scoala de dans"
        ),
        isCustomer: true,
        business: AppointmentBusiness(
            address: "Bulevardul Iuliu Maniu 67, Bucuresti, 077042, Romania",
            coordinates: BusinessCoordinates(
                lat: 44.433552,
                lng: 26.020075
            )
        )
    ),
    Appointment(
        id: 3,
        startDate: Date(),
        endDate: Date().addingTimeInterval(3600),
        channel: "scroll_booker",
        status: AppointmentStatus(raw: "cancelled"),
        message: "Am gasit o oferta mai buna",
        product: AppointmentProduct(
            id: 2,
            name: "Curs de dans bachata",
            price: 100.0,
            priceWithDiscount: 50.0,
            discount: 0.0,
            currency: "RON",
            exchangeRate: 1.0
        ),
        user: AppointmentUser(
            id: 2,
            avatar: "https://media.scrollbooker.ro/avatar-male-9.jpeg",
            fullName: "Salsa Factory",
            username: "@salsa_factory",
            profession: "Scoala de dans"
        ),
        isCustomer: true,
        business: AppointmentBusiness(
            address: "Bulevardul Iuliu Maniu 67, Bucuresti, 077042, Romania",
            coordinates: BusinessCoordinates(
                lat: 44.433552,
                lng: 26.020075
            )
        )
    )
]
