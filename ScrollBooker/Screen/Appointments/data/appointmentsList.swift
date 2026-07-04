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
        channel: AppointmentChannelEnum.scrollBooker,
        status: AppointmentStatus(raw: "confirmed"),
        message: "",
        isCustomer: true,
        products: [
            AppointmentProduct(
                id: 1,
                name: "Tuns Special",
                price: 100,
                priceWithDiscount: 50.0,
                discount: 50,
                duration: 45,
                currency: Currency(id: 1, name: "RON"),
                convertedPriceWithDiscount: 50.0,
                exchangeRate: 1.0
            )
        ],
        user: AppointmentUser(
            id: 1,
            fullName: "Radu Ion",
            username: "@radu_ion",
            avatar: "https://media.scrollbooker.ro/avatar-male-9.jpeg",
            profession: "Stylist",
            ratingsAverage: 4.8,
            ratingsCount: 24
        ),
        customer: AppointmentUser(
            id: 99,
            fullName: "Client Test 1",
            username: "@client1",
            avatar: nil,
            profession: nil,
            ratingsAverage: nil,
            ratingsCount: nil
        ),
        business: AppointmentBusiness(
            address: "Bulevardul Iuliu Maniu 67, Bucuresti, 077042, Romania",
            coordinates: BusinessCoordinates(lat: 44.433552, lng: 26.020075),
            mapUrl: "https://apple.com"
        ),
        totalPrice: 50.0,
        totalPriceWithDiscount: 50.0,
        totalDiscount: 0.0,
        totalDuration: 45,
        paymentCurrency: Currency(id: 1, name: "RON"),
        hasWrittenReview: false,
        hasVideoReview: false,
        writtenReview: nil
    ),
    Appointment(
        id: 2,
        startDate: Date(),
        endDate: Date().addingTimeInterval(3600),
        channel: AppointmentChannelEnum.scrollBooker,
        status: AppointmentStatus(raw: "finished"),
        message: "",
        isCustomer: true,
        products: [
            AppointmentProduct(
                id: 2,
                name: "Curs de dans bachata",
                price: 100.0,
                priceWithDiscount: 50.0,
                discount: 50.0,
                duration: 60,
                currency: Currency(id: 1, name: "RON"),
                convertedPriceWithDiscount: 50.0,
                exchangeRate: 1.0
            )
        ],
        user: AppointmentUser(
            id: 2,
            fullName: "Salsa Factory",
            username: "@salsa_factory",
            avatar: "https://media.scrollbooker.ro/avatar-male-9.jpeg",
            profession: "Scoala de dans",
            ratingsAverage: 4.9,
            ratingsCount: 112
        ),
        customer: AppointmentUser(
            id: 99,
            fullName: "Client Test 1",
            username: "@client1",
            avatar: nil,
            profession: nil,
            ratingsAverage: nil,
            ratingsCount: nil
        ),
        business: AppointmentBusiness(
            address: "Bulevardul Iuliu Maniu 67, Bucuresti, 077042, Romania",
            coordinates: BusinessCoordinates(lat: 44.433552, lng: 26.020075),
            mapUrl: "https://apple.com"
        ),
        totalPrice: 100.0,
        totalPriceWithDiscount: 50.0,
        totalDiscount: 50.0,
        totalDuration: 60,
        paymentCurrency: Currency(id: 1, name: "RON"),
        hasWrittenReview: true,
        hasVideoReview: false,
        writtenReview: AppointmentWrittenReview(id: 10, review: "Un curs excelent!", rating: 5)
    ),
    Appointment(
        id: 3,
        startDate: Date(),
        endDate: Date().addingTimeInterval(3600),
        channel: AppointmentChannelEnum.scrollBooker,
        status: AppointmentStatus(raw: "cancelled"),
        message: "Am gasit o oferta mai buna",
        isCustomer: true,
        products: [
            AppointmentProduct(
                id: 2,
                name: "Curs de dans bachata",
                price: 100.0,
                priceWithDiscount: 50.0,
                discount: 50.0,
                duration: 60,
                currency: Currency(id: 1, name: "RON"),
                convertedPriceWithDiscount: 50.0,
                exchangeRate: 1.0
            )
        ],
        user: AppointmentUser(
            id: 2,
            fullName: "Salsa Factory",
            username: "@salsa_factory",
            avatar: "https://media.scrollbooker.ro/avatar-male-9.jpeg",
            profession: "Scoala de dans",
            ratingsAverage: 4.9,
            ratingsCount: 112
        ),
        customer: AppointmentUser(
            id: 99,
            fullName: "Client Test 1",
            username: "@client1",
            avatar: nil,
            profession: nil,
            ratingsAverage: nil,
            ratingsCount: nil
        ),
        business: AppointmentBusiness(
            address: "Bulevardul Iuliu Maniu 67, Bucuresti, 077042, Romania",
            coordinates: BusinessCoordinates(lat: 44.433552, lng: 26.020075),
            mapUrl: "https://apple.com"
        ),
        totalPrice: 100.0,
        totalPriceWithDiscount: 50.0,
        totalDiscount: 50.0,
        totalDuration: 60,
        paymentCurrency: Currency(id: 1, name: "RON"),
        hasWrittenReview: false,
        hasVideoReview: false,
        writtenReview: nil
    )
]
