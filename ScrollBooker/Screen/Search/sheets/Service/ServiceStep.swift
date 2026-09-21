//
//  ServiceStep.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

struct ServiceStep: View {
    var selectedServiceDomain: ServiceDomain?
    var selectedServiceId: Int?
    var services: [ServiceWithFilters]?
    var isLoadingServices: Bool
    var selectedSubFilterIds: [Int]?

    var onChangeFilter: (Int) -> Void
    var onChangeService: (Int?) -> Void
    var onBack: () -> Void

    private var selectedService: ServiceWithFilters? {
        services?.first(where: { $0.id == selectedServiceId })
    }

    private var serviceOptions: [Option] {
        var list = [Option(value: "0", name: String(localized: "allServices"))]
        if let servicesList = services {
            list.append(contentsOf: servicesList.map {
                Option(value: String($0.id), name: $0.name)
            })
        }
        return list
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                ServiceStepHeader(
                    onBack: onBack,
                    serviceDomainName: selectedServiceDomain?.name,
                    serviceDomainUrl: selectedServiceDomain?.thumbnailUrl
                )

                VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                    InputSelectPlaceholder(
                        options: services != nil ? serviceOptions : [],
                        selectedOption: selectedServiceId != nil ? String(selectedServiceId!) : "0",
                        placeholder: String(localized: "chooseAService"),
                        label: String(localized: "service"),
                        isLoading: isLoadingServices,
                        onValueChange: { newValue in
                            let parsedId = Int(newValue)
                            onChangeService(parsedId == 0 ? nil : parsedId)
                        }
                    )

                    if let service = selectedService {
                        let filteredFilters = service.filters

                        SearchAdvancedFilters(
                            selectedSubFilterIds: selectedSubFilterIds,
                            filters: filteredFilters,
                            onSetSelectedFilter: onChangeFilter
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.horizontal, .base)
                .padding(.top, AppSize.xl.rawValue)
                .animation(.easeInOut(duration: 0.2), value: selectedService?.id)
            }
            .padding(.bottom, AppSize.xxl.rawValue)
        }
    }
}
