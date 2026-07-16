//
//  SearchBusinessRequest.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.07.2026.
//

import Foundation

struct SearchBusinessRequest: Encodable {
    let bbox: BusinessBoundingBox
    let zoom: Float
    let maxMarkers: Int?
    let businessDomainId: Int?
    let serviceDomainId: Int?
    let serviceId: Int?
    let subFilterIds: [Int]?
    let userLocation: BusinessCoordinates?
    let maxPrice: Decimal?
    let sort: String?
    let hasDiscount: Bool
    let startDate: String?
    let startTime: String?
    let endTime: String?

    enum CodingKeys: String, CodingKey {
        case bbox
        case zoom
        case maxMarkers = "max_markers"
        case businessDomainId = "business_domain_id"
        case serviceDomainId = "service_domain_id"
        case serviceId = "service_id"
        case subFilterIds = "subfilter_ids"
        case userLocation = "user_location"
        case maxPrice = "max_price"
        case sort
        case hasDiscount = "has_discount"
        case startDate = "start_date"
        case startTime = "start_time"
        case endTime = "end_time"
    }

    init(
        bbox: BusinessBoundingBox,
        zoom: Float,
        maxMarkers: Int? = nil,
        businessDomainId: Int? = nil,
        serviceDomainId: Int? = nil,
        serviceId: Int? = nil,
        subFilterIds: [Int]? = nil,
        userLocation: BusinessCoordinates? = nil,
        maxPrice: Decimal? = nil,
        sort: String?,
        hasDiscount: Bool = false,
        startDate: String? = nil,
        startTime: String? = nil,
        endTime: String? = nil
    ) {
        self.bbox = bbox
        self.zoom = zoom
        self.maxMarkers = maxMarkers
        self.businessDomainId = businessDomainId
        self.serviceDomainId = serviceDomainId
        self.serviceId = serviceId
        self.subFilterIds = subFilterIds
        self.userLocation = userLocation
        self.maxPrice = maxPrice
        self.sort = sort
        self.hasDiscount = hasDiscount
        self.startDate = startDate
        self.startTime = startTime
        self.endTime = endTime
    }
}

struct BusinessBoundingBox: Encodable {
    let minLng: Float
    let maxLng: Float
    let minLat: Float
    let maxLat: Float

    enum CodingKeys: String, CodingKey {
        case minLng = "min_lng"
        case maxLng = "max_lng"
        case minLat = "min_lat"
        case maxLat = "max_lat"
    }
}
